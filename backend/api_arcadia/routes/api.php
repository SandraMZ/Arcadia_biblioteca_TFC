<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\LibroController;
use App\Http\Controllers\NotificacionController;
use App\Http\Controllers\PrestamoController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::prefix('arcadia')->group(function(){
    //MARK: Rutas para la gestión de la sesión y registro de los usuarios
    Route::prefix('user')->group(function(){
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('/', [AuthController::class, 'getUser']);

    });

    //MARK: Rutas para peticiones que requieren autenticación
    Route::group(['middleware' => ['jwt.verify']], function(){
         //MARK: Funciones del perfil del usuario
        Route::prefix('user')->group(function(){
            //Desactivar la cuenta del usuario
            Route::post('deactivate', [UserController::class, 'deactivate']);

            //Modificar foto de perfil
            Route::post('pfp', [UserController::class, 'updateProfilePicture']);

            //Obtener foto de perfil
            Route::get('pfp', [UserController::class, 'getProfilePicture']);

            //Modificar datos
            //Nombre
            Route::post('name', [UserController::class, 'updateName']);

            //Email
            Route::post('email', [UserController::class, 'updateEmail']);

            //Teléfono
            Route::post('phone_number', [UserController::class, 'updatePhoneNumber']);

            //Fecha de nacimiento
            Route::post('birth_date', [UserController::class, 'updateBirthDate']);

            //DNI o NIE
            Route::post('id_number', [UserController::class, 'updateIDNumber']);

            //Modificar contraseña
            Route::post('password', [UserController::class, 'updatePassword']);

            //Modificar datos del domicilio
            Route::post('address', [UserController::class, 'updateAddress']);

            //Obtener datos del domicilio
            Route::get('address', [UserController::class, 'getAddress']);

            //Comprobar si el usuario está sancionado
            Route::get('sanctioned', [UserController::class, 'isUserSanctioned']);
        });

        //MARK: Notificaciones
        Route::get('notifs', [NotificacionController::class, 'getAllNotifs']);

        //MARK: Listas
        Route::prefix('lists')->group(function(){
            //Recomendaciones
            Route::get('recommended', [LibroController::class, 'recommendedBooks']);

            //Lista de libros a los que les quedan pocos ejemplares
            Route::get('popular', [LibroController::class, 'getPopular']);

            //lista de libros de literatura y ficción
            Route::get('fiction_books', [LibroController::class, 'getFictionBooks']);

            //Lista de deseados
            Route::get('wishlist', [LibroController::class, 'getWishlist']);
            Route::post('wishlist/{id_libro}', [LibroController::class, 'addToWishlist']);
            Route::delete('wishlist/{id_libro}', [LibroController::class, 'deleteFromWishlist']);

            //lista de espera
            Route::get('waiting_list', [LibroController::class, 'getWaitinglist']);
            Route::post('waiting_list/{id_libro}', [LibroController::class, 'addToWaitingList']);
            Route::delete('waiting_list/{id_libro}', [LibroController::class, 'deleteFromWaitingList']);
        });

        //MARK: Libros y préstamos
        Route::prefix('books')->group(function(){
            //Libro individual
            Route::get('{id}', [LibroController::class, 'getBook']);

            //PRÉSTAMOS
            Route::prefix('borrow')->group(function(){
                //Actuales
                Route::get('current', [PrestamoController::class, 'getCurrent']);

                //Anteriores
                Route::get('returned', [PrestamoController::class, 'getReturned']);

                //Pedir préstamo
                Route::post('/{id_libro}', [PrestamoController::class, 'borrow']);

                //Marcar pedido como entregado
                Route::post('delivered/{id_pedido}', [PrestamoController::class, 'bookDelivered']);

                //Alargar préstamo
                Route::post('lengthen_loan/{id_libro}', [PrestamoController::class, 'changeReturnDate']);

                //Devolver préstamo
                Route::post('return/{id_libro}', [PrestamoController::class, 'return']);

                //Devolver la foto del envío guardada en el storage
                Route::get('photo/{id_pedido}', [PrestamoController::class, 'getReturnPhoto']);

                //Imprimir ticket del préstamo
                Route::get('ticket/{id_pedido}', [PrestamoController::class, 'printTicket']);
            });
        });

        //MARK: Búsqueda y filtros
        Route::prefix('filters')->group(function(){
            //Géneros y búsqueda
            //Lista de géneros
            Route::get('genres', [LibroController::class, 'getGenres']);

            //Lista de subgéneros
            Route::get('subgenres/{genre_id}', [LibroController::class, 'getSubgenres']);

            //Lista de libros según género
            Route::get('books_by_genre/{id}', [LibroController::class, 'getBooksByGenre']);

            //Lista de libros según subgénero
            Route::get('books_by_subgenre/{id}', [LibroController::class, 'getBooksBySubgenre']);

            //Lista de libros resultado de la búsqueda
            Route::post('search', [LibroController::class, 'getBooksBySearch']);

            //Datos para rellenar los filtros
            //Lista de años de publicación
            Route::get('publishing_year', [LibroController::class, 'getPublicationYear']);

            //Lista de idiomas
            Route::get('languages', [LibroController::class, 'getLanguages']);
        });

    });
});