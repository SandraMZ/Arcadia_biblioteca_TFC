<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class Usuario extends Authenticatable implements JWTSubject
{
    protected $table = "users";

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'nombre',
        'apellidos',
        'email',
        'password',
        'dni',
        'fecha_nac',
        'telf',
        'pfp',
        'id_domicilio'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'password' => 'hashed',
            'fecha_nac' => 'date'
        ];
    }

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    public function domicilio(): HasOne{
        return $this->hasOne(Domicilio::class, 'id_usuario');
    }

    public function notificaciones(): HasMany{
        return $this->hasMany(Notificacion::class, 'id_usuario');
    }

    public function prestamos(): HasMany{
        return $this->hasMany(Prestamo::class, 'id_usuario');
    }

    public function listasDeEspera(): HasMany{
        return $this->hasMany(ListaDeEspera::class, 'id_usuario');
    }
}
