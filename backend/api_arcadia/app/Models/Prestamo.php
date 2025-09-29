<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Prestamo extends Model
{

    protected $fillable = [
        'id_libro',
        'id_usuario',
        'fecha_pedido',
        'cod_pedido',
        'recibido',
        'fecha_recibido',
        'fecha_devolucion',
        'fecha_devuelto',
        'foto_envio',
        'extension',
        'direccion',
        'piso',
        'puerta',
        'provincia',
        'localidad',
        'cod_postal',
        'email',
        'telf',
        'nombre',
        'apellidos',
        'dni'
    ];

    protected function casts(): array
    {
        return [
            'recibido' => 'boolean',
            'fecha_pedido' => 'date',
            'fecha_recibido' => 'date',
            'fecha_devolucion' => 'date',
            'fecha_devuelto' => 'date',
        ];
    }

    public function usuario(): BelongsTo{
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }

    public function libro(): BelongsTo{
        return $this->belongsTo(Libro::class, 'id_libro');
    }
}
