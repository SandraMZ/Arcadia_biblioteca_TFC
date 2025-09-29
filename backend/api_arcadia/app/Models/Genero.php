<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Genero extends Model
{
    protected $fillable = [
        'nombre'
    ];

    public function subgeneros(): HasMany{
        return $this->hasMany(Subgenero::class, 'id_genero');
    }

    public function libros(): BelongsToMany{
        return $this->belongsToMany(Libro::class, 'genero_libro', 'id_genero', 'id_libro');
    }
}
