<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\BelongsToRelationship;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class Domicilio extends Model
{
    protected $fillable = [
        'direccion',
        'piso',
        'puerta',
        'provincia',
        'localidad',
        'cod_postal',
        'id_usuario'
    ];

    public function usuario(): BelongsTo{
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }
}
