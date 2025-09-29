<?php

namespace App\Http\Controllers;

use App\Models\Libro;
use App\Models\Notificacion;
use App\Models\Prestamo;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;
use Carbon\Carbon;

class NotificacionController extends Controller
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

    //MARK: Lista de todas las notificaciones de un usuario
    public function getAllNotifs(){
        //Llamar a las funciones que comprueban y crean las notificaciones de los préstamos
        $this->returnDateNotif();
        $this->sanctionNotif();

        //Obtener todas las notificaciones del usuario
        $notificaciones = Notificacion::where('id_usuario', '=', $this->user->id)->orderByDesc('id')->get();

        return $notificaciones;
    }


    //MARK: Guardar una notificación cuando el préstamo venza ese día
    private function returnDateNotif(){
        //Petición para conseguir los préstamos que su fecha de devolución sea hoy y aún no se hayan devuelto
        $carbon = new Carbon();
        $prestamosHoy = Prestamo::where('id_usuario','=',$this->user->id)->where('fecha_devolucion', '=', $carbon->now('Europe/Madrid')->format('Y-m-d'))->where('fecha_devuelto', '=', null)->get();

        if(count($prestamosHoy) > 0){
            //Crear una notificación por cada préstamo
            foreach($prestamosHoy as $prestamo){
                $libro = Libro::find($prestamo->id_libro);

                $comprobarNoti = Notificacion::where('fecha', '=', $carbon->now('Europe/Madrid')->format('Y-m-d'))->whereLike('mensaje', "Hoy es el último día del préstamo de '$libro->titulo', ¡no olvides devolverlo a tiempo!")->get();

                if(count($comprobarNoti) <= 0){
                    Notificacion::create([
                        'mensaje' => "Hoy es el último día del préstamo de '$libro->titulo', ¡no olvides devolverlo a tiempo!",
                        'fecha' => $carbon->now('Europe/Madrid'),
                        'id_usuario' => $this->user->id,
                        'id_libro' => $prestamo->id_libro,
                        'portada' => $libro->imagen
                    ]);
                }
            }
        }
    }

    //MARK: Guardar una notificación cuando se haya pasado el plazo para devolver el préstamo (el plazo acabó el día anterior)
    private function sanctionNotif(){
        //Petición para conseguir los préstamos que su fecha de devolución fuese ayer y aún no se hayan devuelto
        $carbon = new Carbon();
        $prestamosAyer = Prestamo::where('id_usuario','=',$this->user->id)->where('fecha_devolucion', '=', $carbon->subDay()->setTimezone('Europe/Madrid')->format('Y-m-d'))->where('fecha_devuelto', '=', null)->get();

        if(count($prestamosAyer) > 0){
            //crear una notificación por cada préstamo atrasado
            foreach($prestamosAyer as $prestamo){
                $libro = Libro::find($prestamo->id_libro);

                $comprobarNoti = Notificacion::where('fecha', '=', $carbon->now('Europe/Madrid')->format('Y-m-d'))->whereLike('mensaje', "¡El último día para devolver '$libro->titulo' fue ayer! No se podrán hacer más préstamos hasta que se devuelva")->get();

                if(count($comprobarNoti) <= 0){
                    Notificacion::create([
                        'mensaje' => "¡El último día para devolver '$libro->titulo' fue ayer! No se podrán hacer más préstamos hasta que se devuelva",
                        'fecha' => $carbon->now('Europe/Madrid'),
                        'id_usuario' => $this->user->id,
                        'id_libro' => $prestamo->id_libro,
                        'portada' => $libro->imagen
                    ]);
                }
            }
        }
    }
}
