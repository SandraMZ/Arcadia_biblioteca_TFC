<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\Domicilio;
use App\Models\ListaDeEspera;
use App\Models\Notificacion;
use App\Models\Prestamo;
use App\Models\Usuario;
use App\Models\Wishlist;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Exceptions\JWTException;

class UserController extends Controller
{
    //MARK: OBTENER EL USUARIO ASOCIADO AL TOKEN
    protected $user;

    public function __construct(){
        $token = JWTAuth::getToken();
        if($token != ''){
            try{
                $this->user = JWTAuth::parseToken()->authenticate();
            } catch(JWTException $e){

            }
        }
    }

    //MARK: DESACTIVAR CUENTA
    public function deactivate(Request $request){
        //obtener el email enviado para confirmar la desactivación y validar el formulario/ campo
        $confirmacion = $request->only('email');

        $validator = Validator::make($confirmacion, [
            'email' => 'required|email'
        ], [
            'required' => 'Campo obligatorio',
            'email' => 'Campo para correo electrónico'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //si el formulario se valida, comprobar si el email recibido es igual al del usuario obtenido por el token
        if($confirmacion['email'] == $this->user['email']){
            //si el email es correcto, eliminar todas las filas de las tablas que le correspondan al usuario
            $this->user->update([
                'id_domicilio' => null
            ]);
            Domicilio::where('id_usuario', '=', $this->user['id'])->delete();
            Wishlist::where('id_usuario', '=', $this->user['id'])->delete();
            ListaDeEspera::where('id_usuario', '=', $this->user['id'])->delete();
            Notificacion::where('id_usuario', '=', $this->user['id'])->delete();
            Prestamo::where('id_usuario', '=', $this->user['id'])->delete();

            //eliminar el usuario
            $deleted = Usuario::destroy($this->user['id']);

            //invalidar el token
            try {
                JWTAuth::invalidate(JWTAuth::getToken());
            } catch(JWTException $e){
                return response()->json([
                    'success' => -10, //error inesperado, no tiene que ver con el código escrito, sino con JWT
                    'message' => 'Error al eliminar el token'
                ], Response::HTTP_INTERNAL_SERVER_ERROR);
            }

            return response()->json([
                'success' => 1,
                'message' => 'Usuario eliminado',
                'id' => $deleted
            ], Response::HTTP_OK);
        } else {
            //el email no coincide con el del usuario
            return response()->json([
                'success' => -2, //error en las credenciales
                'message' => 'Correo electrónico incorrecto'
            ], 401);
        }
    }

    //MARK: CAMBIAR FOTO DE PERFIL
    public function updateProfilePicture(Request $request){
        //comprobar si se ha enviado un archivo por el formulario
        if($request->hasFile('image')){
            //guardar la imagen recibida en el storage privado
            $image = $request->file('image')->store('uploads', 'private');
            $urlImage = basename($image); //obtener sólo la imagen de la ruta de almacenamiento
        } else {
            //si no se ha enviado un archivo, se comprueba si se ha enviado un enlace.
            //Esta comprobación se hace especialmente para poder comprobar por Postman que funciona la petición
            if($request->has('url')){
                $url = $request->only('url');

                //validar el campo del formulario
                $validator = Validator::make($url, [
                    'url' => 'required|string'
                ], [
                    'required' => 'Campo obligatorio',
                    'string' => 'Campo de tipo texto'
                ]);

                if($validator->fails()){
                    return response()->json([
                        'success' => -1, //error en la validación
                        'message' => 'Errores en la validación',
                        'validator' => $validator->messages()
                    ], 400);
                }

                $urlImage = $url['url'];
            } else {
                return response()->json([
                    'success' => -1, //error en la validación
                    'message' => 'El campo de la imagen es obligatorio'
                ], 400);
            }

        }

        //cambiar la foto de perfil del usuario por la guardada en el storage
        $this->user->update([
            'pfp' => $urlImage
        ]);

        return response()->json([
            'success' => 1, //ok
            'message' => 'Foto de perfil actualizada',
            'photo' => $this->user['pfp']
        ], Response::HTTP_OK);
    }

    //MARK: Devolver la foto de perfil guardada en el storage
    public function getProfilePicture(){
        $path = 'uploads/' . $this->user->pfp;
        //comprobar que existe este directorio en el storage privado
        if (!Storage::disk('private')->exists($path)) {
            abort(404);
        }

        $file = Storage::disk('private')->get($path); //obtener el archivo
        //obtener el tipo archivo
        $fullPath = Storage::disk('private')->path($path);
        $mimeType = mime_content_type($fullPath);

        return response($file, 200)->header('Content-Type', $mimeType); //devolver el archivo para poder mostrarlo
    }

    //MARK: CAMBIAR DATOS
    //MARK: Nombre y apellidos
    public function updateName(Request $request){
        //Obtener los datos del formulario y validarlos
        $data = $request->only('nombre', 'apellidos');

        $validator = Validator::make($data, [
            'nombre' => 'required|string',
            'apellidos' => 'required|string',
        ], [
            'required' => 'Campo obligatorio',
            'string' => 'Campo de tipo texto'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //cambiar los datos del usuario
        $this->user->update([
            'nombre' => $data['nombre'],
            'apellidos' => $data['apellidos']
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Nombre y apellidos actualizados',
            'user' => $this->user
        ], Response::HTTP_OK);
    }

    //MARK: Correo
    public function updateEmail(Request $request){
        //Obtener los datos del formulario y validarlos
        $data = $request->only('email');

        $validator = Validator::make($data, [
            'email' => 'required|email|unique:users'
        ], [
            'required' => 'Campo obligatorio',
            'email' => 'Campo para correo electrónico',
            'unique' => 'Correo no disponible'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //cambiar el correo del usuario
        $this->user->update([
            'email' => $data['email']
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Correo actualizado',
            'user' => $this->user
        ], Response::HTTP_OK);
    }

    //MARK: Teléfono
    public function updatePhoneNumber(Request $request){
        //Obtener los datos del formulario y validarlos
        $data = $request->only('telf');

        //eliminar los espacios en blanco entre los números, por si los usuarios los han escrito en otros formatos (000 000 000 || 000 00 00 00)
        if(strpos($data['telf'], ' ') !== false){
            $data['telf'] = str_replace(' ', '', $data['telf']);
        }

        $validator = Validator::make($data, [
            'telf' => 'required|string|regex:/^[0-9]{9}$/'
        ], [
            'required' => 'Campo obligatorio',
            'string' => 'Campo de tipo texto',
            'regex' => 'Formato no válido'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //cambiar el teléfono del usuario
        $this->user->update([
            'telf' => $data['telf']
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Número de teléfono actualizado',
            'user' => $this->user
        ], Response::HTTP_OK);
    }

    //MARK: Fecha de nacimiento
    public function updateBirthDate(Request $request){
        //Obtener los datos del formulario y validarlos
        $data = $request->only('fechaNac');

        //sustituir / por - en la fecha para que se ajuste al formato de la base de datos
        if(strpos($data['fechaNac'], '/') !== false){
            $data['fechaNac'] = str_replace('/', '-', $data['fechaNac']);
        }

        $validator = Validator::make($data, [
            'fechaNac' => ['required', 'regex:/^([0-3]?[0-9])-([01]?[0-9])-([0-9]{4})$/']
        ], [
            'required' => 'Campo obligatorio',
            'regex' => 'Formato incorrecto'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //convertir el string recogido en una fecha con el formato y la zona horaria correcta
        $fechaNacimiento = new Carbon($data['fechaNac'], 'Europe/Madrid')->format('Y-m-d');

        //guardar los cambios en la fecha de nacimiento del usuario
        $this->user->update([
            'fecha_nac' => $fechaNacimiento
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Fecha de nacimiento actualizada',
            'user' => $this->user
        ], Response::HTTP_OK);
    }

    //MARK: DNI o NIE
    public function updateIDNumber(Request $request){
        //Obtener los datos del formulario y validarlos
        $data = $request->only('dni');

        $validator = Validator::make($data, [
            'dni' => ['required', 'string', 'min:9', 'max:12', 'regex:/^(?:[XYZ]-?|[0-9])[0-9]{7}-?[A-Z]$/']
        ], [
            'required' => 'Campo obligatorio',
            'string' => 'Campo de tipo texto',
            'max' => 'Máximo :max caracteres',
            'min' => 'Al menos :min caracteres',
            'regex' => 'Formato incorrecto'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //guardar los cambios en el dni del usuario
        $this->user->update([
            'dni' => $data['dni']
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Número identificativo actualizado',
            'user' => $this->user
        ], Response::HTTP_OK);
    }


    //MARK: CAMBIAR CONTRASEÑA
    public function updatePassword(Request $request){
        //se obtienen del formulario la contraseña anterior, la nueva y la confirmación de la nueva contraseña
        $data = $request->only('anteriorPass', 'nuevaPass', 'nuevaPass_confirmation');

        //validar los datos
        $validator = Validator::make($data, [
            'anteriorPass' => 'required|string|min:8|max:16|current_password:api', //current_password:api compara que la contraseña introducida sea igual a la que ya está guardada en la base de datos
            'nuevaPass' => 'required|string|min:8|max:16|confirmed', //confirmed indica que tras este campo va a haber uno de confirmación. Comprueba que ambos campos tengan el mismo valor
            'nuevaPass_confirmation' => 'required|string|min:8|max:16'
        ], [
            'required' => 'Campo obligatorio',
            'string' => 'Campo de tipo texto',
            'current_password' => 'Contraseña incorrecta',
            'confirmed' => 'La confirmación no coincide',
            'max' => 'Máximo :max caracteres',
            'min' => 'Al menos :min caracteres'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //guardar la nueva contraseña
        $this->user->update([
            'password' => $data['nuevaPass']
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Contraseña actualizada'
        ], Response::HTTP_OK);
    }

    //MARK: CAMBIAR DATOS DE ENVÍO
    public function updateAddress(Request $request){
        //Obtener los datos del formulario de domicilio y validarlos
        $data = $request->only('nombre', 'apellidos', 'direccion', 'piso', 'puerta', 'provincia', 'localidad', 'codPostal', 'telf');

        //eliminar los espacios en blanco entre los números del teléfono, por si los usuarios los han escrito en otros formatos (000 000 000 || 000 00 00 00)
        if(strpos($data['telf'], ' ') !== false){
            $data['telf'] = str_replace(' ', '', $data['telf']);
        }

        if($data['telf'] != "") {
            $validator = Validator::make($data, [
                'nombre' => 'required|string',
                'apellidos' => 'required|string',
                'direccion' => 'required|string',
                'piso' => 'sometimes',
                'puerta' => 'sometimes',
                'provincia' => 'required|string',
                'localidad' => 'required|string',
                'codPostal' => 'required|string|min:5|max:5',
                'telf' => 'string|regex:/^[0-9]{9}$/'
            ], [
                'required' => 'Campo obligatorio',
                'string' => 'Campo de tipo texto',
                'max' => 'Máximo :max caracteres',
                'min' => 'Al menos :min caracteres',
                'regex' => 'Formato no válido'
            ]);

            if($validator->fails()){
                return response()->json([
                    'success' => -1, //error en la validación
                    'message' => 'Errores en la validación',
                    'validator' => $validator->messages()
                ], 400);
            }
        } else {
            $validator = Validator::make($data, [
                'nombre' => 'required|string',
                'apellidos' => 'required|string',
                'direccion' => 'required|string',
                'piso' => 'sometimes',
                'puerta' => 'sometimes',
                'provincia' => 'required|string',
                'localidad' => 'required|string',
                'codPostal' => 'required|string|min:5|max:5',
                'telf' => 'sometimes'
            ], [
                'required' => 'Campo obligatorio',
                'string' => 'Campo de tipo texto',
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
        }

        //buscar si ya existe una dirección asociada al usuario obtenido desde el token
        $direccion = Domicilio::whereLike('id_usuario', $this->user->id)->first();

        //si ya hay una dirección asociada, se modifican sus datos
        if($direccion){
            $direccion->update([
                'direccion' => $data['direccion'],
                'piso' => $data['piso'],
                'puerta' => $data['puerta'],
                'provincia' => $data['provincia'],
                'localidad' => $data['localidad'],
                'cod_postal' => $data['codPostal']
            ]);
        //si no hay ninguna dirección asociada, se crea una
        } else {
            $direccion = Domicilio::create([
                'direccion' => $data['direccion'],
                'piso' => $data['piso'],
                'puerta' => $data['puerta'],
                'provincia' => $data['provincia'],
                'localidad' => $data['localidad'],
                'cod_postal' => $data['codPostal'],
                'id_usuario' => $this->user['id']
            ]);
            $this->user->update([
                'id_domicilio' => $direccion->id
            ]);
        }

        //se modifican también los datos del usuario que se han introducido en el formulario
        if($data['telf'] != null && $data['telf'] != ""){
            $this->user->update([
                'nombre' => $data['nombre'],
                'apellidos' => $data['apellidos'],
                'telf' => $data['telf']
            ]);
        } else {
            $this->user->update([
                'nombre' => $data['nombre'],
                'apellidos' => $data['apellidos']
            ]);
        }

        return response()->json([
            'success' => 1,
            'message' => 'Datos del envío actualizados',
            'user' => $this->user,
            'address' => $direccion
        ], Response::HTTP_OK);
    }

    //MARK: CONSEGUIR EL DOMICILIO DEL USUARIO POR SU ID
    public function getAddress(){
        $domicilio = Domicilio::where('id_usuario', '=', $this->user->id)->first();

        if($domicilio != null){
            return response()->json([
                'success' => 1,
                'message' => 'El usuario tiene un domicilio relacionado',
                'address' => $domicilio
            ], Response::HTTP_OK);
        } else {
            return response()->json([
                'success' => 1,
                'message' => 'El usuario no tiene un domicilio relacionado'
            ], Response::HTTP_OK);
        }
    }

    //MARK: COMPROBAR SI SE PUEDEN PEDIR LIBROS PRESTADOS O SI HAY ALGUNA SANCIÓN
    public function isUserSanctioned(){
        //obtener los préstamos del usuario que tengan fecha de devolución y que no han sido devueltos
        $ultimosPrestamos = Prestamo::where('id_usuario', $this->user->id)->where('fecha_devolucion', '<>', NULL)->where('fecha_devuelto', '=', NULL)->orderByDesc('fecha_pedido')->get();

        //Parámetros que se van a enviar en la respuesta y van a cambiar si hay préstamos fuera de plazo
        $sanctioned = 0;
        $message = 'El usuario no está sancionado';
        $idLibrosFueraDePlazo = [];

        foreach($ultimosPrestamos as $ultimoPrestamo){
            if($ultimoPrestamo->recibido == true){
                //comprobar si la fecha de devolución es anterior a la fecha actual
                $fechaDevolucion = new Carbon($ultimoPrestamo->fecha_devolucion, 'Europe/Madrid')->format('Y-m-d');
                $ahora = new Carbon('Europe/Madrid')->format('Y-m-d');
                 //el usuario está sancionado porque se le ha pasado la fecha de entrega
                if($ahora > $fechaDevolucion){
                    //Se cambia el valor del estado y el mensaje y se guarda el id del libro que está fuera de plazo
                    $sanctioned = 1;
                    $message = 'El usuario está sancionado';
                    $idLibrosFueraDePlazo[] = $ultimoPrestamo->id_libro;
                }
            }
        }

        return response()->json([
            'sanctioned' => $sanctioned,
            'message' => $message,
            'late_loans' => $idLibrosFueraDePlazo
        ], Response::HTTP_OK);
    }
}