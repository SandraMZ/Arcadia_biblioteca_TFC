<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Libro extends Model
{
    protected $primaryKey = 'id';

    public $incrementing = false;

    protected $fillable = [
        'id',
        'titulo',
        'subtitulo',
        'editorial',
        'isbn_13',
        'idioma',
        'n_paginas',
        'publicacion',
        'descripcion',
        'imagen',
        'encuadernacion',
        'disponibles',
        'prestados'
    ];

    protected function casts(): array
    {
        return [
            'publicacion' => 'date'
        ];
    }

    public function prestamos(): HasMany{
        return $this->hasMany(Prestamo::class, 'id_libro');
    }

    public function listasDeEspera(): HasMany{
        return $this->hasMany(ListaDeEspera::class, 'id_libro');
    }

    public function autores(): BelongsToMany{
        return $this->belongsToMany(Autor::class, 'autor_libro', 'id_libro', 'id_autor');
    }

    public function generos(): BelongsToMany{
        return $this->belongsToMany(Genero::class, 'genero_libro', 'id_libro', 'id_genero');
    }

    public function subgeneros(): BelongsToMany{
        return $this->belongsToMany(Subgenero::class, 'libro_subgenero', 'id_libro', 'id_subgenero');
    }

    public function notificaciones(): HasMany{
        return $this->hasMany(Notificacion::class, 'id_libro');
    }
}
