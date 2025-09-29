<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket del préstamo</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

    <style>
        .ticket{
            width: 709px;
            height: 2364px;
            background-color: #FDECE7;
            color: #A57865;
            text-align: center;
            font-family: Poppins;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
        }

        .ticket>div{
            margin: 118px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .portada{
            width: 400px;
            height: 571px;
            border-radius: 6px;
        }

        h2{
            font-size: 52px;
            font-weight: 600;
            margin-top: 0px;
            margin-bottom: 60px;
        }

        h3{
            font-size: 40px;
            font-weight: 500;
            margin-top: 32px;
            margin-bottom: 0px;
        }

        .autor{
            margin-top: 16px;
            font-size: 32px;
            font-weight: 400;
        }

        .usuario{
            font-size: 28px;
            font-weight: 300;
            margin-top: 80px;
        }

        .aviso {
            font-size: 32px;
            font-weight: 500;
        }

        .logo{
            width: 80px;
            height: 80px;
            margin-top: 24px;
        }
    </style>
</head>
<body>
    <div class="ticket">
        <div>
            <h2>Préstamo<br>{{ $codPedido }}</h2>
            <img src="{{ $portada }}" class="portada">
            <h3>{{ $titulo }}</h3>
            <h3 class="autor">{{ $autor }}</h3>
            <p class="usuario">{{ $user }} - {{ $fecha }}</p>
        </div>
        <div>
            <p class="aviso">¡No olvides incluirme en la foto al hacer tu devolución!</p>
            <img src="{{ asset('storage/uploads/logo_arcadia.png') }}" class="logo">
        </div>
    </div>
</body>
</html>