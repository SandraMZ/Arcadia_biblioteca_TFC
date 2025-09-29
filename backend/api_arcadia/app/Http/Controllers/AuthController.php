<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller
{
    //MARK: REGISTRO
    public function register(Request $request){
        //obtener los datos enviados por el formulario de registro y validarlos
        $data = $request->only('nombre', 'apellidos', 'email', 'password');

        $validator = Validator::make($data, [
            'nombre' => 'required|string',
            'apellidos' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:8|max:16'
        ], [
            'required' => 'Campo obligatorio',
            'string' => 'Campo de tipo texto',
            'email' => 'Campo para correo electrónico',
            'unique' => 'Correo no disponible',
            'max' => 'Máximo :max caracteres',
            'min' => 'Al menos :min caracteres',
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //si la validación es correcta, se crea el usuario
        Usuario::create($data);

        //Como es un usuario nuevo, se inicia sesión directamente con el email y la contraseña
        $credentials = $request->only('email', 'password');

        try{
            $token = JWTAuth::attempt($credentials);
        }catch(JWTException $e){
            return response()->json([
                'success' => -10, //error inesperado, no tiene que ver con el código escrito, sino con JWT
                'message' => 'Error inesperado. Reinténtalo de nuevo'
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        return response()->json([
            'success' => 1, //ok
            'message' => 'Usuario creado',
            'token' => $token,
            'user' => Auth::user()
        ], Response::HTTP_OK);
    }

    //MARK: INICIAR SESIÓN
    public function login(Request $request){
        //obtener el correo y la contraseña enviados por el formulario de inicio de sesión y validarlos
        $credentials = $request->only('email', 'password');

        $validator = Validator::make($credentials, [
            'email' => 'required|email',
            'password' => 'required|string|min:8|max:16'
        ], [
            'required' => 'Campo obligatorio',
            'string' => 'Campo de tipo texto',
            'email' => 'Campo para correo electrónico',
            'max' => 'Máximo :max caracteres',
            'min' => 'Al menos :min caracteres',
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //si el formulario es válido, se prueba si las credenciales son correctas para iniciar sesión
        try{
            if(!$token = JWTAuth::attempt($credentials)){
                //si las credenciales son incorrectas
                return response()->json([
                    'success' => -2, //error en las credenciales
                    'message' => 'Credenciales incorrectas'
                ], 401);
            }
        }catch(JWTException $e){
            return response()->json([
                'success' => -10, //error inesperado, no tiene que ver con el código escrito
                'message' => 'Error inesperado. Reinténtalo de nuevo'
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        //inicio de sesión correcto
        return response()->json([
            'success' => 1,
            'message' => 'Sesión iniciada',
            'token' => $token,
            'user' => Auth::user()
        ], Response::HTTP_OK);
    }

    //MARK: CERRAR SESIÓN
    public function logout(){
        //Se invalida el token que se estaba usando hasta ahora
        try {
            JWTAuth::invalidate(JWTAuth::getToken());
            return response()->json([
                'success' => 1,
                'message' => 'Sesión cerrada'
            ], Response::HTTP_OK);
        } catch(JWTException $e){
            return response()->json([
                'success' => -10,
                'message' => 'Error inesperado. Reinténtalo de nuevo'
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    //MARK: OBTENER EL USUARIO POR EL TOKEN PARA COMPROBAR QUE NO SE HA CERRADO SESIÓN
    public function getUser(){
        //Autenticar el token que se estaba utilizando
        $token = JWTAuth::getToken();

        try{
            $user = JWTAuth::authenticate($token);
            if($user){
                return response()->json([
                    'success' => 1, //ok
                    'message' => 'Sesión abierta',
                    'user' => $user,
                    'token' => "$token"
                ], Response::HTTP_OK);
            } else {
                return response()->json([
                    'success' => -4, //no se ha encontrado usuario para este token
                    'message' => 'Usuario no encontrado para un token válido. Cierra sesión para desactivar el token',
                    'token' => "$token"
                ], 404);
            }

        } catch(JWTException $e){
            return response()->json([
                'success' => -3, //token no válido
                'message' => 'Sesión cerrada o token no válido',
                'token' => "$token"
            ], 401);
        }
    }

}
