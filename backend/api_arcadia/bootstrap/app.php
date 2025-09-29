<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->alias([
            'jwt.verify' => \App\Http\Middleware\JWTMiddleware::class,
            'jwt.auth' => 'Tymon\JWTAuth\Middleware\GetUserFromToken',
            'jwt.refresh' => 'Tymon\JWTAuth\Middleware\RefreshToken'
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();
