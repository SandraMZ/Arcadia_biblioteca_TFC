<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Notificacion extends Model
{
    protected $table = 'notificaciones';

    protected $fillable = [
        'mensaje',
        'fecha',
        'id_usuario',
        'id_libro',
        'portada'
    ];

    protected function casts(): array
    {
        return [
            'fecha' => 'date'
        ];
    }

    public function usuario(): BelongsTo{
        return $this->belongsTo(Usuario::class, 'id_usuario');
    }
    public function libro(): BelongsTo{
        return $this->belongsTo(Libro::class, 'id_libro');
    }
}
