<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Subgenero extends Model
{
    protected $fillable = [
        'nombre',
        'id_genero'
    ];

    public function genero(): BelongsTo{
        return $this->belongsTo(Genero::class, 'id_genero');
    }

    public function libros(): BelongsToMany{
        return $this->belongsToMany(Libro::class, 'libro_subgenero', 'id_subgenero', 'id_libro');
    }
}