<?php

namespace App\Http\Controllers;

use App\Models\Autor;
use App\Models\Genero;
use App\Models\Libro;
use App\Models\ListaDeEspera;
use App\Models\Prestamo;
use App\Models\Subgenero;
use App\Models\Wishlist;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;
use Symfony\Component\HttpFoundation\Response;

class LibroController extends Controller
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

    //MARK: LIBRO INDIVIDUAL
    public function getBook(string $id){
        //Encontrar el libro por su id
        $libro = Libro::find($id);
        if($libro == null){
            return response()->json([
                'success' => -4, //no encontrado
                'message' => 'Libro no encontrado'
            ]);
        }

        //Obtener los autores, géneros y subgéneros del libro
        $autores = $libro->autores()->get();
        $generos = $libro->generos()->get();
        $subgeneros = $libro->subgeneros()->get();

        //Obtener libros de los autores
        $autoresId = []; //array con los ids de los autores
        foreach($autores as $autorLibro){
            $autoresId[] = $autorLibro->id;
        }
        $librosAutores = $this->getBooksByAuthor($autoresId, $id); //obtener una lista con todos los libros de los autores de este libro que NO incluya este libro y que no tenga libros repetidos

        //Estado del libro: en préstamo al usuario, agotado o disponible y no en préstamo
        $status = 0; //disponible y no en préstamo
        $recibido = 0; //no recibido

        //Comprobar si el usuario ya ha pedido este libro prestado
        $libroEnPrestamo = Prestamo::whereLike('id_libro', $id)->where('id_usuario', '=', $this->user->id)->where('fecha_devuelto', '=', null)->get();

        if(count($libroEnPrestamo) > 0){
            $status = 1; //prestado
            if($libroEnPrestamo[0]->fecha_recibido != null && $libroEnPrestamo[0]->fecha_recibido != ""){
                $recibido = 1;
            }
        }

        //Comprobar si el libro está agotado
        if($libro->disponibles <= 0 && $status != 1){
            $status = 2; //agotado
        }

        //Comprobar si el libro está en la lista de deseados
        $onWishlist = 0; //no está en la lista de deseos

        $libroEnWishlist = Wishlist::whereLike('id_libro', $id)->where('id_usuario', '=', $this->user->id)->get();

        if(count($libroEnWishlist) > 0){
            $onWishlist = 1; //está en la lista de deseos
        }

        //Comprobar si el libro está en la lista de espera
        $onWaitingList = 0; //no está en la lista de espera

        $libroEnWaitingList = ListaDeEspera::whereLike('id_libro', $id)->where('id_usuario', '=', $this->user->id)->get();

        if(count($libroEnWaitingList) > 0){
            $onWaitingList = 1; //está en la lista de espera
        }

        //Respuesta con todos los datos y estados del libro
        return response()->json([
            'success' => 1, //ok
            'message' => 'Libro encontrado',
            'status' => $status,
            'received' => $recibido,
            'onWishlist' => $onWishlist,
            'onWaitingList' => $onWaitingList,
            'book' => $libro,
            'authors' => $autores,
            'otherBooks' => $librosAutores,
            'genres' => $generos,
            'subgenres' => $subgeneros
        ]);
    }

    //MARK: Obtener una lista de todos los libros escritos los autores de un libro
    private function getBooksByAuthor(array $idsAutores, string $id_libro){
        //Petición para obtener los datos de todos los libros de todos los autores cuya ID sea alguna de las guardadas en el array $idsAutores. Los libros no pueden estar repetidos y no puede devolverse tampoco el libro original
        $libros = Autor::join('autor_libro', 'autores.id', '=', 'autor_libro.id_autor')
        ->join('libros', 'libros.id', '=', 'autor_libro.id_libro')
        ->distinct()
        ->select('autor_libro.id_libro', 'libros.titulo', 'libros.subtitulo', 'libros.editorial', 'libros.isbn_13', 'libros.idioma', 'libros.n_paginas', 'libros.publicacion', 'libros.descripcion', 'libros.encuadernacion', 'libros.imagen', 'libros.disponibles', 'libros.prestados')
        ->whereIn('autores.id', $idsAutores)
        ->whereNot('libros.id', $id_libro)
        ->get();

        //Nuevo array para guardar objetos que, además de tener los datos de los libros, también incluyen todos los autores de cada libro obtenido en la petición anterior
        $librosLista = [];
        foreach($libros as $libro){
            //Petición para conseguir los datos de los autores de uno de los libros del array
            $autores = Libro::join('autor_libro', 'libros.id', '=', 'autor_libro.id_libro')
            ->join('autores', 'autores.id', '=', 'autor_libro.id_autor')
            ->select('autores.*')
            ->where('libros.id', $id_libro)
            ->get();

            //Se guarda en $librosLista un objeto con los datos del libro + su array de autores
            $librosLista[] = [
                'libro' => [
                    "id" => $libro['id_libro'],
                    "titulo" => $libro['titulo'],
                    "subtitulo" => $libro['subtitulo'],
                    "editorial" => $libro['editorial'],
                    "isbn_13" => $libro['isbn_13'],
                    "idioma" => $libro['idioma'],
                    "n_paginas" => $libro['n_paginas'],
                    "publicacion" => $libro['publicacion'],
                    "descripcion" => $libro['descripcion'],
                    "encuadernacion" => $libro['encuadernacion'],
                    "imagen" => $libro['imagen'],
                    "disponibles" => $libro['disponibles'],
                    "prestados" => $libro['prestados']
                ],
                'autores' => $autores
            ];
        }

        return $librosLista;
    }

    //MARK: Recomendaciones
    //Devuelve una lista de máximo 12 libros aleatorios que pertenecen a los mismos géneros que los tres últimos libros que el usuario ha tomado prestados
    public function recommendedBooks(){
        //se seleccionan los tres últimos libros en préstamo por el usuario
        $lista3ultimosLibrosID = Prestamo::whereLike('id_usuario', $this->user->id)->select('id_libro')->orderByDesc('id')->limit(3)->get();

        $librosRecomendados = []; //array de los libros recomendados
        //Se comprueba si el usuario tiene algún préstamo hecho
        if(count($lista3ultimosLibrosID) > 0){
            $listaGenerosID = [];
            //se selecciona el primer género de cada uno de los tres libros
            foreach($lista3ultimosLibrosID as $libroID){
                $listaGenerosID[] = Libro::find($libroID['id_libro'])->generos()->first()->id;
            }

            // se seleccionan 4 libros aleatorios por cada uno de los tres géneros
                //(Si el género del libro prestado tiene menos de 4 títulos, entonces se devuelve sólo la cantidad de libros que tenga, no se repiten los títulos para llegar a 4 elementos)
            foreach($listaGenerosID as $generoID){
                $librosGen = Genero::find($generoID)->libros()->distinct()->orderBy(DB::raw('RAND()'))->limit(4)->get();

                foreach($librosGen as $libro){
                    $autores = $libro->autores()->get();

                    $librosRecomendados[] = [
                        'libro' => $libro,
                        'autores' => $autores
                    ];
                }
            }
        } else {
            //Si el usuario no ha hecho ningún préstamo todavía, se guardan en el array 12 libros aleatorios de la base de datos
            $librosGen = Libro::distinct()->orderBy(DB::raw('RAND()'))->limit(12)->get();

            foreach($librosGen as $libro){
                $autores = $libro->autores()->get();

                $librosRecomendados[] = [
                    'libro' => $libro,
                    'autores' => $autores
                ];
            }
        }

        $librosNoRepetidosAsoc = array_unique($librosRecomendados, SORT_REGULAR); //Filtrar los libros recomendados para que no haya ninguno repetido en la lista. Si filtra, pasa a ser un array asociativo

        //Para que siempre se devuelva array y evitar que a veces sea array asociativo/ diccionario
        $librosNoRepetidos = [];

        foreach($librosNoRepetidosAsoc as $key => $value){
            $librosNoRepetidos[] = $value;
        }

        //Se devuelve un array con un máximo de 12 libros si no hay ninguno repetido (de tener el usuario al menos tres libros pedidos y dichos géneros tener 4 o más títulos. Si sólo ha pedido un libro, devuelve un array de 4 libros; si ha pedido dos, un array de 8 libros aleatorios.)
        return $librosNoRepetidos;

    }

    //MARK: Libros en la lista de deseados
    public function getWishlist(){
        $getWishlist = Wishlist::where('id_usuario', $this->user->id)->orderByDesc('fecha')->get();

        $libros = [];
        foreach($getWishlist as $item){
            $libro = Libro::find($item->id_libro);
            $autores = $libro->autores()->get();

            $libros[] = [
                'libro' => $libro,
                'autores' => $autores
            ];
        }

        return $libros;
    }

    //MARK: Añadir a la lista de deseados
    public function addToWishlist(string $id_libro){
        //Comprobar si el libro ya está en la lista de deseos
        $select = Wishlist::whereLike('id_libro', $id_libro)->where('id_usuario', $this->user->id)->get();

        if(count($select) > 0){
            return response()->json([
                'success' => -3, //repetido cuando debe ser único
                'message' => 'Libro repetido en la lista de deseos'
            ], 400);
        }

        //Si el libro no está repetido, se guarda en la lista
        $carbon = new \Carbon\Carbon;
        $wishlist = Wishlist::create([
            'id_usuario' => $this->user->id,
            'id_libro' => $id_libro,
            'fecha' => $carbon->now()
        ]);

        return response()->json([
            'success' => 1, //ok
            'message' => 'Libro guardado en la lista de deseos',
            'listItem' => $wishlist
        ], Response::HTTP_OK);
    }

    //MARK: Eliminar de la lista de deseados
    public function deleteFromWishlist(string $id_libro){
        $wishlist = Wishlist::whereLike('id_libro', $id_libro)->where('id_usuario', $this->user->id)->delete();

        return response()->json([
            'success' => 1, //ok
            'message' => 'Libro eliminado de la lista de deseos',
            'nItems' => $wishlist
        ], Response::HTTP_OK);
    }

    //MARK: Libros en la lista de espera
    public function getWaitinglist(){
        $getWaitingList = ListaDeEspera::where('id_usuario', $this->user->id)->orderByDesc('fecha')->get();
        $libros = [];
        foreach($getWaitingList as $item){
            $libro = Libro::find($item->id_libro);
            $autores = $libro->autores()->get();

            $libros[] = [
                'libro' => $libro,
                'autores' => $autores
            ];
        }

        return $libros;
    }

    //MARK: Añadir a la lista de espera
    public function addToWaitingList(string $id_libro){
        //Comprobar si el libro ya está en la lista de espera
        $select = ListaDeEspera::whereLike('id_libro', $id_libro)->where('id_usuario', $this->user->id)->get();

        if(count($select) > 0){
            return response()->json([
                'success' => -3,
                'message' => 'Libro repetido en la lista de espera'
            ], 400);
        }

        //Si el libro no está repetido, se guarda en la lista
        $carbon = new \Carbon\Carbon;
        $waitingList = ListaDeEspera::create([
            'id_usuario' => $this->user->id,
            'id_libro' => $id_libro,
            'fecha' => $carbon->now()
        ]);

        return response()->json([
            'success' => 1,
            'message' => 'Libro guardado en la lista de espera',
            'listItem' => $waitingList
        ], Response::HTTP_OK);
    }

    //MARK: Eliminar de la lista de espera
    public function deleteFromWaitingList(string $id_libro){
        $waitingList = ListaDeEspera::whereLike('id_libro', $id_libro)->where('id_usuario', $this->user->id)->delete();

        return response()->json([
            'success' => 1,
            'message' => 'Libro eliminado de la lista de espera',
            'nItems' => $waitingList
        ], Response::HTTP_OK);
    }


    //MARK: Lista de libros a los que les quedan pocos ejemplares (5 o menos)
    public function getPopular(){
        $librosPopulares = Libro::where('disponibles', '<=', 5)->get();

        $libros = [];
        foreach($librosPopulares as $item){
            //$libro = Libro::find($item->id);
            $autores = $item->autores()->get();

            $libros[] = [
                'libro' => $item, //$libro,
                'autores' => $autores
            ];
        }
        return $libros;
    }

    //MARK: Lista de libros del género literatura y ficción
    public function getFictionBooks(){
        $librosFiccion = Genero::find(7)->libros()->distinct()->orderBy('titulo')->get();

        $libros = [];
        foreach($librosFiccion as $item){
            //$libro = Libro::find($item->id);
            $autores = $item->autores()->get();

            $libros[] = [
                'libro' => $item, //$libro,
                'autores' => $autores
            ];
        }
        return $libros;
    }

    //MARK: GÉNEROS Y BÚSQUEDA
    //MARK: Lista de géneros
    public function getGenres(){
        return Genero::get();
    }

    //MARK: Lista de subgéneros pertenecientes a un género
    public function getSubgenres(int $genre_id){
        return Genero::findOrFail($genre_id)->subgeneros()->get();
    }

    //MARK: Lista de libros según género
    public function getBooksByGenre(int $id){
        if(Genero::find($id)){
            $librosGenero = Genero::find($id)->libros()->orderBy('titulo')->get();

            $libros = [];
            foreach($librosGenero as $item){
                //$libro = Libro::find($item->id);
                $autores = $item->autores()->get();

                $libros[] = [
                    'libro' => $item, //$libro,
                    'autores' => $autores
                ];
            }
            return $libros;
        } else {
            return [];
        }
    }

    //MARK: Lista de libros según subgénero
    public function getBooksBySubgenre(int $id){
        if(Subgenero::find($id)){
            $librosSubgenero = Subgenero::find($id)->libros()->get();

            $libros = [];
            foreach($librosSubgenero as $item){
                //$libro = Libro::find($item->id);
                $autores = $item->autores()->get();

                $libros[] = [
                    'libro' =>$item,  //$libro,
                    'autores' => $autores
                ];
            }
            return $libros;
        } else {
            return [];
        }
    }

    //MARK: Lista de libros resultado de la búsqueda
    public function getBooksBySearch(Request $request){
        //validar el campo de búsqueda
        $req = $request->only('search');

        $validator = Validator::make($req, [
            'search' => 'required|string'
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

        //si no hay errores en la validación, se devuelven todos los libros en los que la búsqueda coincida parcialmente con su título o editorial y en los que la búsqueda coincida totalmente con su isbn
        $search = $req['search'];
        $libros = Libro::whereLike('titulo', "%$search%")->orWhereLike('editorial', "%$search%")->orWhereLike('isbn_13', "$search")->get();

        //búsqueda por autores
        //Obtener todos los autores cuyo nombre coincida parcialmente con la búsqueda
        $autores = Autor::whereLike('nombre', "%$search%")->get();
        $librosAutor = [];
        foreach($autores as $autor){
            $librosAutor[] = $autor->libros()->get();
        }

        //guardar en el array $results los resultados de ambas peticiones + su array de autores
        $result = [];
        foreach($libros as $item){
            //$libro = Libro::find($item->id);
            $autores = $item->autores()->get();

            $result[] = [
                'libro' => $item, //$libro,
                'autores' => $autores
            ];
        }

        foreach($librosAutor as $autores){
            foreach($autores as $item){
                //$libro = Libro::find($item->id);
                $autores = $item->autores()->get();

                $result[] = [
                    'libro' => $item, //$libro,
                    'autores' => $autores
                ];
            }
        }

        return $result;
    }

    //MARK: FILTROS
    //MARK: Lista de años de publicación
    public function getPublicationYear(){
        $publicationDates = Libro::select('publicacion')->distinct()->orderByDesc('publicacion')->get();

        $yearString = []; //array de substrings
        $year = []; //array de tipo fecha para poder ordenar las fechas correctamente al devolverlas
        foreach($publicationDates as $date){
            //Comprobar que el substring no está ya guardado en el array
            if(!in_array( substr($date['publicacion'], 0, 4), $yearString)){
                $yearString[] = substr($date['publicacion'], 0, 4); //substrings
                $year[] = date(substr($date['publicacion'], 0, 4)); //fechas
            }
        }

        sort($year);

        return $year;
    }

    //MARK: Lista de idiomas
    public function getLanguages(){
        $idiomas = Libro::select('idioma')->distinct()->get();

        $idiomasString = [];
        foreach($idiomas as $idioma){
            $idiomasString[] = $idioma['idioma'];
        }

        return $idiomasString;
    }
}
