<?php

namespace App\Http\Controllers;

use App\Models\Libro;
use App\Models\ListaDeEspera;
use App\Models\Notificacion;
use App\Models\Prestamo;
use App\Models\Usuario;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;

class PrestamoController extends Controller
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

    //MARK: Obtener lista de préstamos activos
    public function getCurrent()
    {
        //Petición para los préstamos que aún no han sido devueltos
        $librosPrestados = Prestamo::whereLike('id_usuario',$this->user->id)->where('fecha_devuelto', '=', null)->orderByDesc('id')->select('id_libro', 'fecha_devolucion', 'cod_pedido')->get();

        //Por cada préstamo, obtener el libro asociado y sus autores
        $libros = [];
        foreach($librosPrestados as $prestamo){
            $libro = Libro::find($prestamo['id_libro']);
            $autores = $libro->autores()->get();

            $libros[] =[
                'devolucion' => $prestamo['fecha_devolucion'],
                'cod_pedido' => $prestamo['cod_pedido'],
                'libro' => $libro,
                'autores' => $autores
            ];
        }

        return $libros;
    }

    //MARK: Obtener lista de préstamos que ya han sido devueltos
    public function getReturned()
    {
        //Petición para los préstamos que aún han sido devueltos
        $librosPrestados = Prestamo::whereLike('id_usuario', $this->user->id)->where('fecha_devuelto', '<>', NULL)->orderByDesc('fecha_devuelto')->select('id_libro', 'fecha_pedido')->get();

        //Por cada préstamo, obtener el libro asociado y sus autores
        $libros = [];
        foreach($librosPrestados as $prestamo){
            $libro = Libro::find($prestamo['id_libro']);
            $autores = $libro->autores()->get();

            $libros[] =[
                'devolucion' => $prestamo['fecha_pedido'],
                'libro' => $libro,
                'autores' => $autores
            ];
        }

        return $libros;
    }

    //MARK: Hacer préstamo
    public function borrow(Request $request, string $id_libro){
        //Obtener los datos del formulario y validarlos
        $data = $request->only('direccion', 'piso', 'puerta', 'provincia', 'localidad', 'cod_postal', 'telf', 'email', 'nombre', 'apellidos', 'dni');

        $validator = Validator::make($data, [
            'direccion' => 'required|string',
            'piso' => 'sometimes',
            'puerta' => 'sometimes',
            'provincia' => 'required|string',
            'localidad' => 'required|string',
            'cod_postal' => 'required|string|min:5|max:5',
            'email' => 'required|email',
            'telf' => 'sometimes',
            'nombre' => 'required|string',
            'apellidos' => 'required|string',
            'dni' => ['required', 'string', 'min:9', 'max:12', 'regex:/^(?:[XYZ]-?|[0-9])[0-9]{7}-?[A-Z]$/']
        ], [
            'email' => 'Campo para correo electrónico',
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

        //Comprobar de que el libro del que se ha solicitado el préstamo está disponible
        $libro = Libro::whereLike('id', $id_libro)->first();
        if($libro->disponibles <= 0){
            return response()->json([
                'success' => -4, //no encontrado
                'message' => 'No hay más ejemplares disponibles de este título'
            ], 400);
        }

        //Si hay ejemplares disponibles, crear el préstamo
        $carbon = new Carbon;
        $prestamo = Prestamo::create([
            'id_usuario' => $this->user->id,
            'id_libro' => $id_libro,
            'fecha_pedido' => $carbon->now('Europe/Madrid'),
            'cod_pedido' => substr(uniqid(), 0, -5),
            'recibido' => 0,
            'direccion' => $data['direccion'],
            'piso' => $data['piso'],
            'puerta' => $data['puerta'],
            'provincia' => $data['provincia'],
            'localidad' => $data['localidad'],
            'cod_postal' => $data['cod_postal'],
            'email' => $data['email'],
            'telf' => $data['telf'],
            'nombre' => $data['nombre'],
            'apellidos' => $data['apellidos'],
            'dni' => $data['dni'],
        ]);

        //Modificar el número de ejemplares disponibles y prestados del título
        $libro->update([
            'disponibles' => $libro->disponibles - 1,
            'prestados' => $libro->prestados + 1
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Préstamo guardado',
            'loan' => $prestamo,
            'book' => $libro
        ], 200);
    }

    //MARK: Imprimir el ticket del préstamo
    //Petición pensada para ver en postman
    public function printTicket(int $id_pedido){
        $pedido = Prestamo::find($id_pedido);

        if($pedido != null) {
            $libro = Libro::find($pedido->id_libro);
            $autores =  Libro::find($pedido->id_libro)->autores()->get();

            $autoresNombre = "";

            foreach($autores as $autor){
                if($autoresNombre == ""){
                    $autoresNombre = $autor->nombre;
                } else {
                    $autoresNombre .= ", $autor->nombre";
                }
            }

            $fechaPedido = new Carbon($pedido->fecha_pedido, 'Europe/Madrid')->format('d/m/Y');
            $user = Usuario::find($pedido->id_usuario);
            $nombreUser = $user->nombre . ' ' . $user->apellidos;

            return view('ticket', ["codPedido" => $pedido->cod_pedido, "portada" => $libro->imagen, "titulo" => $libro->titulo, "autor" => $autoresNombre, "user" => $nombreUser, "fecha" => $fechaPedido]);
        } else {
            echo "No hay ningún préstamo con ese pedido.";
        }
    }

    //MARK: Darle una fecha de devolución al pedido al ser entregado al usuario
    public function bookDelivered(int $id_pedido){
        $carbon = new Carbon();
        $ahora = $carbon->now('Europe/Madrid');

        $pedido = Prestamo::find($id_pedido);

        if($pedido != null){
            //Comprobar si el préstamo ya ha sido recibido o no
            if($pedido->recibido == 0 && $pedido->fecha_recibido == null){
                //Si aún no se ha recibido, modificarlo y ponerle una fecha de devolución dentro de tres semanas desde la fecha de recibo
                $update = $pedido->update([
                    'recibido' => 1,
                    'fecha_recibido' => $ahora,
                    'fecha_devolucion' => $carbon->add('week', 3)->setTimezone('Europe/Madrid')
                ]);

                return response()->json([
                    'success' => 1,
                    'message' => 'Se ha recibido el libro',
                    'nItems' => $update,
                    'loan' => Prestamo::find($id_pedido)
                ]);
            } else {
                //Si ya se ha recibido, mostrar un error
                return response()->json([
                    'success' => -5, //no se puede modificar
                    'message' => 'Este pedido ya se ha marcado como recibido'
                ]);
            }
        } else {
            //Si no existe ese medido
            return response()->json([
                'success' => -4,
                'message' => 'Este pedido no existe'
            ]);
        }
    }

    //MARK: Alargar préstamo
    public function changeReturnDate(Request $request, string $id_libro){
        //Obtener los datos del formulario y validarlos
        $formulario = $request->only('extension', 'motivo');

        $validator = Validator::make($formulario, [
            'extension' => 'required|int',
            'motivo' => 'sometimes'
        ], [
            'required' => 'Campo obligatorio',
            'int' => 'Campo numérico'
        ]);

        if($validator->fails()){
            return response()->json([
                'success' => -1, //error en la validación
                'message' => 'Errores en la validación',
                'validator' => $validator->messages()
            ], 400);
        }

        //Obtener la fecha de devolución actual del préstamo
        $originalDate = Prestamo::where('id_usuario','=',$this->user->id)->whereLike('id_libro', $id_libro)->where('recibido', '=', 1)->where('fecha_devuelto', '=', null)->select('fecha_devolucion')->first();

        //Mostrar un error si todavía no tiene fecha de devolución
        if($originalDate == null){
            return response()->json([
                'success' => -5, //no se puede modificar
                'message' => 'Este préstamo aún no tiene una fecha de devolución a la que aplicarle los cambios o ya ha sido devuelto'
            ]);
        }

        //Crear una nueva fecha añadiéndole a la actual el número de semanas indicadas en el formulario
        $extended = new Carbon($originalDate['fecha_devolucion'], 'Europe/Madrid');
        $extended->add('week', intval($formulario['extension']))->setTimezone('Europe/Madrid');

        //Cambiar la fecha de devolución del préstamo
        $update = Prestamo::where('id_usuario','=',$this->user->id)->whereLike('id_libro', $id_libro)->where('recibido', '=', 1)->where('fecha_devuelto', '=', NULL)->update([
            'fecha_devolucion' => $extended,
            'extension' => $formulario['motivo']
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Fecha cambiada',
            'originalDate' => $originalDate['fecha_devolucion'],
            'extendedDate' => $extended,
            'nItems' => $update
        ]);
    }

    //MARK: Devolver un libro
    public function return(Request $request, string $id_libro){
        //comprobar si se ha enviado un archivo por el formulario
        if($request->hasFile('paquete')){
            //guardar la imagen recibida en el storage
            $image = $request->file('paquete')->store('uploads', 'private');
            $image = basename($image); //obtener sólo la imagen de la ruta de almacenamiento
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

                $image = $url['url'];
            } else {
                return response()->json([
                    'success' => -1,
                    'message' => 'El campo de imagen es obligatorio'
                ], 400);
            }

        }

        //Modificar el préstamo para rellenar los datos de devolución
        $update = Prestamo::where('id_usuario','=',$this->user->id)->whereLike('id_libro', $id_libro)->where('recibido', '=', 1)->where('fecha_devuelto', '=', NULL)->update([
            'fecha_devuelto' => new Carbon(),
            'foto_envio' => $image
        ]);

        //Comprobar que el préstamo existe
        if($update != null){
            //Modificar el número de ejemplares disponibles y prestados del título
            $libroPrestado = Libro::find($id_libro);
            if($libroPrestado->prestados > 0){
                $libroPrestado->update([
                    'disponibles' => $libroPrestado->disponibles + 1,
                    'prestados' => $libroPrestado->prestados - 1
                ]);

                //Si se devuelve un libro que no estaba disponible, se manda una notificación a todos los usuarios que estaban en la lista de espera de ese título
                if($libroPrestado->disponibles == 1){
                    $this->notifyBookAvailable($id_libro);
                }

                return response()->json([
                    'success' => 1,
                    'message' => 'Ejemplar devuelto',
                    'nItems' => $update
                ]);
            } else {
                return response()->json([
                    'success' => -4,
                    'message' => 'No hay ejemplares en préstamo de este título'
                ]);
            }
        } else {
            return response()->json([
                'success' => -4,
                'message' => 'No existe ningún préstamo que se pueda devolver'
            ]);
        }
    }

    //MARK: Crear notificación cuando un libro de la lista de espera vuelva a estar disponible
    private function notifyBookAvailable(string $id_libro){
        $carbon = new Carbon();
        $listasEspera = ListaDeEspera::whereLike('id_libro', $id_libro)->get();

        if($listasEspera){
            foreach($listasEspera as $lista){
                $libro = Libro::find($id_libro);

                Notificacion::create([
                    'mensaje' => '¡El libro que guardaste vuelve a estar disponible!',
                    'fecha' => $carbon->now('Europe/Madrid')->format('Y-m-d'),
                    'id_usuario' => $lista->id_usuario,
                    'id_libro' => $id_libro,
                    'portada' => $libro->imagen
                ]);
            }
        }
    }

    //MARK: Devolver la foto del envío guardada en el storage
    //Petición pensada para ver en postman
    public function getReturnPhoto(int $id_prestamo){
        $prestamo = Prestamo::find($id_prestamo);

        if($prestamo != null){
            $path = 'uploads/' . $prestamo->foto_envio;
            //comprobar que existe este directorio en el storage privado
            if (!Storage::disk('private')->exists($path)) {
                echo "No se encuentra esa imagen en el storage";
                return;
            }

            $file = Storage::disk('private')->get($path); //obtener el archivo
            //obtener el tipo archivo
            $fullPath = Storage::disk('private')->path($path);
            $mimeType = mime_content_type($fullPath);

            return response($file, 200)->header('Content-Type', $mimeType); //devolver el archivo para poder mostrarlo
        } else {
            echo "No existe ningún préstamo con esa id en la base de datos.";
            return;
        }
    }
}
