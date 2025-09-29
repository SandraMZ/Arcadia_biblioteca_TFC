<?php

namespace App\Http\Middleware;

use Closure;
use Exception;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Facades\JWTAuth;
//use \Tymon\JWTAuth\Exceptions\TokenInvalidException;

//Middleware para comprobar el estado del token generado para el usuario
class JWTMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
        } catch (Exception $e){
            if($e instanceof \Tymon\JWTAuth\Exceptions\TokenInvalidException){
                return response()->json(['status' => 'El token no es válido'], 401);
            } else if ($e instanceof \Tymon\JWTAuth\Exceptions\TokenExpiredException){
                return response()->json(['status' => 'El token ha caducado'], 401);
            } else {
                return response()->json(['status' => 'No se ha encontrado el token'], 401);
            }
        }

        return $next($request);
    }
}
