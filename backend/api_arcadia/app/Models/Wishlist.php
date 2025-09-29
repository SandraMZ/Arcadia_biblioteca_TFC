<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Wishlist extends Model
{
    protected $table = 'wishlist';

    protected $fillable = [
        'id_libro',
        'fecha',
        'id_usuario'
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
