-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: vl25818.dinaserver.com:3306
-- Tiempo de generación: 03-06-2025 a las 17:38:55
-- Versión del servidor: 10.5.29-MariaDB-0+deb11u1-log
-- Versión de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tfc_biblio`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autores`
--

CREATE TABLE `autores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autores`
--

INSERT INTO `autores` (`id`, `nombre`) VALUES
(4, 'Brandon Sanderson'),
(5, 'Katherine Howe'),
(6, 'Mercedes Ron'),
(9, 'José Ignacio Valenzuela'),
(11, 'DK'),
(12, 'Polly Dunbar'),
(13, 'Juan Gabriel Vasquez'),
(14, 'Sandra Badillo'),
(15, 'Maribel Riaza'),
(16, 'Sergio Beguería'),
(17, 'Juan Domínguez'),
(18, 'Rubens García'),
(19, 'Anne Rice'),
(20, 'Mary Higgins Clark'),
(21, 'Alafair Burke'),
(22, 'Malcolm Lowry'),
(23, 'Joaquín Cámara'),
(24, 'Frank Herbert'),
(26, 'Rupert L. Swan'),
(27, 'Paola Roig'),
(28, 'Guillermo Cabrera Infante'),
(29, 'Thomas Mann'),
(31, 'Orson Scott Card'),
(32, 'Elsa Jenner'),
(33, 'Manuel P. Villatoro'),
(34, 'Israel Viana'),
(35, 'Diego Galdino'),
(37, 'Adolfo Bioy Casares'),
(38, 'Yolanda Fleta'),
(39, 'Jaime Giménez'),
(40, 'Lara Lombarte'),
(41, 'Nieves Herrero'),
(42, 'Albert Camus'),
(43, 'Laura Fernández'),
(44, 'César Cervera'),
(45, 'Robert Louis Stevenson'),
(47, 'Lev Tolstói'),
(48, 'Fiódor M. Dostoievski'),
(49, 'Lewis Carroll'),
(50, 'Catulo'),
(51, 'Bram Stoker'),
(52, 'Homero'),
(54, 'Anton Chéjov'),
(55, 'Pedro Calderón de la Barca'),
(56, 'Emilia Pardo Bazán'),
(60, 'William Shakespeare'),
(61, 'Henry James'),
(63, 'Manuel Rivas'),
(64, 'Graciela Montes'),
(65, 'Ema Wolf'),
(68, 'Jorge Franco'),
(69, 'Carla Guelfenbein'),
(71, 'Ramírez Sergio'),
(72, 'Luis Leante'),
(76, 'Laura Restrepo'),
(79, 'Manuel Vicent'),
(80, 'Jorge Volpi'),
(84, 'Taschen Publishing'),
(86, 'Magdalena Droste'),
(90, 'Rose-Marie Hagen'),
(91, 'TASCHEN'),
(92, 'Rainer Hagen'),
(94, 'Peter Fiell'),
(95, 'Benedikt TASCHEN'),
(96, 'Charlotte Fiell'),
(98, 'Marianne Barrucand'),
(99, 'Achim Bednorz'),
(105, 'Dan Brown'),
(106, 'Stan Lee'),
(107, 'Adam Bray'),
(110, 'Hiromu Arakawa'),
(111, 'Agatha Christie'),
(112, 'Esther Gili'),
(113, 'Anónimo'),
(115, 'Benito Pérez Galdós'),
(116, 'Víctor García de la Concha'),
(117, 'María del Mar Cortés Timoner'),
(118, 'María José Rodríguez Mosquera'),
(119, 'H. G. Wells'),
(120, 'Jane Austen'),
(121, 'Jules Verne'),
(122, 'Sun Tzu'),
(123, 'Rhiannon Paget'),
(124, 'Moebius'),
(125, 'Alejandro Jodorowsky'),
(126, 'José Ladrönn');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor_libro`
--

CREATE TABLE `autor_libro` (
  `id_autor` int(11) DEFAULT NULL,
  `id_libro` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autor_libro`
--

INSERT INTO `autor_libro` (`id_autor`, `id_libro`) VALUES
(4, 'gdhJEAAAQBAJ'),
(5, 'SOjIDAAAQBAJ'),
(6, '8jFVDgAAQBAJ'),
(9, 'Tj1zBwAAQBAJ'),
(12, 'B0bvNwAACAAJ'),
(13, 'GGaREAAAQBAJ'),
(14, 'zIoTEAAAQBAJ'),
(15, 'aKz6EAAAQBAJ'),
(16, 'mM4eEQAAQBAJ'),
(17, 'mM4eEQAAQBAJ'),
(18, 'A8oVEQAAQBAJ'),
(19, '1pX-AgAAQBAJ'),
(20, 'p6nWEAAAQBAJ'),
(21, 'p6nWEAAAQBAJ'),
(22, 'xQNmEAAAQBAJ'),
(23, 'GkIXEQAAQBAJ'),
(24, 'uf5NEAAAQBAJ'),
(26, 'HUMjEAAAQBAJ'),
(27, 'oPinEAAAQBAJ'),
(28, 'MjA0EAAAQBAJ'),
(29, 'SC47EAAAQBAJ'),
(32, 'B_XDEAAAQBAJ'),
(33, 'poasEAAAQBAJ'),
(34, 'poasEAAAQBAJ'),
(35, 'XlKIEAAAQBAJ'),
(37, 'KJZeEAAAQBAJ'),
(19, 'Eas4AwAAQBAJ'),
(38, 'pcM2EAAAQBAJ'),
(39, 'pcM2EAAAQBAJ'),
(40, 'pcM2EAAAQBAJ'),
(41, 'zE0aEAAAQBAJ'),
(42, 'TDlPEAAAQBAJ'),
(31, 'FfsVCgAAQBAJ'),
(43, 'GRHAEAAAQBAJ'),
(33, '0qYJEAAAQBAJ'),
(44, '0qYJEAAAQBAJ'),
(45, 'cqahDAAAQBAJ'),
(47, 'ZOhWEAAAQBAJ'),
(49, '8hfwCwAAQBAJ'),
(50, '49aCDwAAQBAJ'),
(51, 'yr6CyVLtOmoC'),
(54, 'wVHKDAAAQBAJ'),
(56, 'QqccCwAAQBAJ'),
(60, '94D_CgAAQBAJ'),
(61, 'pNyJEAAAQBAJ'),
(63, 'E5pBEAAAQBAJ'),
(64, 'Q6V_yuqA2hMC'),
(65, 'Q6V_yuqA2hMC'),
(68, 'RHQgAwAAQBAJ'),
(69, 'HfepCAAAQBAJ'),
(71, '--SiQBe51WQC'),
(72, 'hmN4m0y6byAC'),
(76, 'KylVT18NAh4C'),
(79, '9XBdtQW57NQC'),
(80, 'u_9JDwAAQBAJ'),
(86, 'PUeCAAAACAAJ'),
(90, 'VSFzzgEACAAJ'),
(91, 'VSFzzgEACAAJ'),
(92, 'VSFzzgEACAAJ'),
(84, '0atkAAAACAAJ'),
(95, '0atkAAAACAAJ'),
(91, '_H7poAEACAAJ'),
(94, '_H7poAEACAAJ'),
(96, '_H7poAEACAAJ'),
(98, 'iQtQPQAACAAJ'),
(99, 'iQtQPQAACAAJ'),
(105, 'G-TJtAEACAAJ'),
(11, 'kO_IEAAAQBAJ'),
(106, 'kO_IEAAAQBAJ'),
(107, 'kO_IEAAAQBAJ'),
(106, 'FdQ-EQAAQBAJ'),
(106, 'jgzZEAAAQBAJ'),
(125, 'p_AYEQAAQBAJ'),
(125, 'FqEkEQAAQBAJ'),
(110, '910-AwAAQBAJ'),
(110, 'zqw8AwAAQBAJ'),
(110, 'iF0-AwAAQBAJ'),
(110, '2rA8AwAAQBAJ'),
(111, 'i8mXDwAAQBAJ'),
(111, '3jjIEAAAQBAJ'),
(111, 'JW1nEAAAQBAJ'),
(111, 'A2HcEAAAQBAJ'),
(112, 'A2HcEAAAQBAJ'),
(52, 'ybQVwwEACAAJ'),
(52, 'YjLFswEACAAJ'),
(115, 'ilPkDwAAQBAJ'),
(55, 'XIQZQwAACAAJ'),
(116, '6dwVtgEACAAJ'),
(117, '6dwVtgEACAAJ'),
(118, '6dwVtgEACAAJ'),
(119, 'HAuSDwAAQBAJ'),
(120, 'Frh-CgAAQBAJ'),
(121, 'bsYtDwAAQBAJ'),
(122, 'lX9gzwEACAAJ'),
(123, '0atkAAAACAAJ'),
(111, '3jjIEAAAQ54L'),
(124, 'jgzZEAAAQBAJ'),
(124, 'p_AYEQAAQBAJ'),
(124, 'FqEkEQAAQBAJ'),
(126, 'FqEkEQAAQBAJ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('biblioteca_arcadia_cache_7FSejMm4Psb0HXHB', 's:7:\"forever\";', 2064329841);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `domicilios`
--

CREATE TABLE `domicilios` (
  `id` int(11) NOT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `piso` varchar(20) DEFAULT NULL,
  `puerta` varchar(20) DEFAULT NULL,
  `provincia` varchar(45) DEFAULT NULL,
  `localidad` varchar(100) DEFAULT NULL,
  `cod_postal` varchar(10) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `updated_at` date NOT NULL DEFAULT current_timestamp(),
  `created_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `domicilios`
--

INSERT INTO `domicilios` (`id`, `direccion`, `piso`, `puerta`, `provincia`, `localidad`, `cod_postal`, `id_usuario`, `updated_at`, `created_at`) VALUES
(1, 'Calle San Jerónimo, 15', '1', 'A', 'Granada', 'Granada', '18001', 1, '2025-06-03', '2025-06-03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `generos`
--

CREATE TABLE `generos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `generos`
--

INSERT INTO `generos` (`id`, `nombre`) VALUES
(1, 'Arte y entretenimiento'),
(2, 'Salud, cuerpo y mente'),
(3, 'Biografías y memorias'),
(7, 'Ficción y literatura'),
(9, 'Historia'),
(11, 'Filosofía'),
(15, 'Libros infantiles');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `genero_libro`
--

CREATE TABLE `genero_libro` (
  `id_genero` int(11) DEFAULT NULL,
  `id_libro` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `genero_libro`
--

INSERT INTO `genero_libro` (`id_genero`, `id_libro`) VALUES
(2, 'pcM2EAAAQBAJ'),
(7, 'B_XDEAAAQBAJ'),
(7, 'G-TJtAEACAAJ'),
(7, 'ZOhWEAAAQBAJ'),
(7, '1pX-AgAAQBAJ'),
(1, '0atkAAAACAAJ'),
(1, 'iQtQPQAACAAJ'),
(7, '3jjIEAAAQBAJ'),
(7, '3jjIEAAAQ54L'),
(7, 'A2HcEAAAQBAJ'),
(7, 'xQNmEAAAQBAJ'),
(7, 'p6nWEAAAQBAJ'),
(1, 'PUeCAAAACAAJ'),
(1, 'jgzZEAAAQBAJ'),
(1, 'FdQ-EQAAQBAJ'),
(1, 'p_AYEQAAQBAJ'),
(1, 'FqEkEQAAQBAJ'),
(9, '0qYJEAAAQBAJ'),
(15, 'E5pBEAAAQBAJ'),
(7, 'HfepCAAAQBAJ'),
(7, 'cqahDAAAQBAJ'),
(7, 'wVHKDAAAQBAJ'),
(7, '8jFVDgAAQBAJ'),
(7, 'KylVT18NAh4C'),
(1, '_H7poAEACAAJ'),
(7, 'yr6CyVLtOmoC'),
(11, 'lX9gzwEACAAJ'),
(9, 'SOjIDAAAQBAJ'),
(2, 'zIoTEAAAQBAJ'),
(2, 'HUMjEAAAQBAJ'),
(7, 'RHQgAwAAQBAJ'),
(7, 'XlKIEAAAQBAJ'),
(7, 'FfsVCgAAQBAJ'),
(3, 'TDlPEAAAQBAJ'),
(7, 'Eas4AwAAQBAJ'),
(7, 'KJZeEAAAQBAJ'),
(7, 'Q6V_yuqA2hMC'),
(7, 'GRHAEAAAQBAJ'),
(7, 'bsYtDwAAQBAJ'),
(15, 'bsYtDwAAQBAJ'),
(7, 'pNyJEAAAQBAJ'),
(9, 'poasEAAAQBAJ'),
(7, 'ybQVwwEACAAJ'),
(2, 'oPinEAAAQBAJ'),
(7, 'HAuSDwAAQBAJ'),
(1, 'zqw8AwAAQBAJ'),
(1, 'iF0-AwAAQBAJ'),
(1, '2rA8AwAAQBAJ'),
(1, '910-AwAAQBAJ'),
(2, 'A8oVEQAAQBAJ'),
(7, 'XIQZQwAACAAJ'),
(9, 'aKz6EAAAQBAJ'),
(7, '6dwVtgEACAAJ'),
(7, 'zE0aEAAAQBAJ'),
(7, 'SC47EAAAQBAJ'),
(7, 'i8mXDwAAQBAJ'),
(7, 'JW1nEAAAQBAJ'),
(7, 'QqccCwAAQBAJ'),
(1, 'VSFzzgEACAAJ'),
(3, 'MjA0EAAAQBAJ'),
(7, '--SiQBe51WQC'),
(2, 'mM4eEQAAQBAJ'),
(1, 'kO_IEAAAQBAJ'),
(15, 'Tj1zBwAAQBAJ'),
(7, 'hmN4m0y6byAC'),
(7, 'YjLFswEACAAJ'),
(7, 'Frh-CgAAQBAJ'),
(15, 'B0bvNwAACAAJ'),
(7, '49aCDwAAQBAJ'),
(7, 'uf5NEAAAQBAJ'),
(7, '9XBdtQW57NQC'),
(2, 'GkIXEQAAQBAJ'),
(7, '94D_CgAAQBAJ'),
(3, 'u_9JDwAAQBAJ'),
(15, 'FfsVCgAAQBAJ'),
(7, 'ilPkDwAAQBAJ'),
(7, 'gdhJEAAAQBAJ'),
(7, '8hfwCwAAQBAJ'),
(7, 'GGaREAAAQBAJ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libros`
--

CREATE TABLE `libros` (
  `id` varchar(50) NOT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `subtitulo` varchar(255) DEFAULT NULL,
  `editorial` varchar(100) DEFAULT NULL,
  `isbn_13` varchar(20) DEFAULT NULL,
  `idioma` varchar(10) DEFAULT NULL,
  `n_paginas` int(11) DEFAULT NULL,
  `publicacion` varchar(25) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `encuadernacion` enum('Tapa dura','Tapa blanda','De bolsillo','') DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `disponibles` int(11) DEFAULT NULL,
  `prestados` int(11) DEFAULT NULL,
  `created_at` date DEFAULT current_timestamp(),
  `updated_at` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libros`
--

INSERT INTO `libros` (`id`, `titulo`, `subtitulo`, `editorial`, `isbn_13`, `idioma`, `n_paginas`, `publicacion`, `descripcion`, `encuadernacion`, `imagen`, `disponibles`, `prestados`, `created_at`, `updated_at`) VALUES
('--SiQBe51WQC', 'Margarita, está linda la mar (Premio Alfaguara de novela 1998)', '', 'ALFAGUARA', '9788420433370', 'es', 384, '2017-12-13', 'Una novela perfecta, rebosante de nobleza. Una obra excepcional que fue galardonada con el Premio Alfaguara de novela de 1998.\r\n\r\nPor el ganador del Premio Cervantes 2017.\r\n\r\n1907. León, Nicaragua. Durante un homenaje que le rinde su ciudad natal, Ruben Darío escribe en el abanico de una niña de nueve años uno de sus más hermosos poemas: \"Margarita, está linda la mar...\".\r\n\r\n1956. En un cafe de León, una tertulia se reúne desde hace años, dedicada, entre otras cosas, a la rigurosa reconstrucción de la leyenda del poeta. Pero tambien a conspirar. Anastasio Somoza visita la ciudad, en compañía de su esposa, doña Salvadorita. Está previsto un banquete de pompa y boato. Habrá un atentado contra la vida del tirano, y aquella niña del abanico, medio siglo más tarde, no será ajena a los hechos.\r\n\r\nSergio Ramírez logra, en Margarita, está linda la mar, que toda la historia de su país quepa en una cumplida metáfora de realidad y leyenda. En un lenguaje cuya brillantez subyuga al lector, con ráfagas de humor e ironía que asombran por su precisión poética, la acción va tramando caminos de medio siglo entre los dos niveles del relato, creando un continuo temporal entre el pasado y el presente que parece pertenecer a los mejores territorios del mito. Y dentro de este ámbito literario, con mucha más realidad que los hechos concretos, el amor nos hace conocer personajes de impecable identidad, originales, tiernos, necesarios, inscritos en la mejor tradición de las grandes personalidades de la literatura latinoamericana.', 'Tapa blanda', 'https://imagessl0.casadellibro.com/a/l/s7/70/9788420433370.webp', 10, 0, '2025-04-02', '2025-04-02'),
('0atkAAAACAAJ', 'Hokusai', '', 'Taschen', '9783836599986', 'es', 96, '2025-01-06', 'Conozca al artista cuyo majestuoso influjo se difundió por todo el mundo. Hokusai (1760-1849) no es sólo uno de los gigantes del arte japones y una leyenda del periodo Edo, sino tambien uno de los fundadores de la modernidad occidental. Su prolífica gama de grabados, ilustraciones y pinturas conforma una de las expresiones más completas del genero artístico ukiyo-e, y es una de las referencias fundamentales del japonismo. Su influencia alcanzó al impresionismo, el Art Nouveau y el Jugendstil, entre otros, y cautivó a autores de la talla de Claude Monet (que compró 23 de sus grabados), Berthe Morisot, Edgar Degas, Mary Cassatt y Vincent van Gogh. Hokusai fue siempre un hombre activo. A lo largo de su vida cambió de domicilio más de 90 veces y sustituyó su propio nombre por al menos siete seudónimos profesionales. En su arte mostró la misma inquietud, cubriendo el espectro completo del ukiyo-e japonés (la pinturas del mundo flotante), que es un genero pictórico y de grabados realizados mediante xilografía en el que se encuadran desde estampas sueltas con paisajes y actores hasta álbumes de grabados e ilustraciones para antologías poéticas y novelas.', 'Tapa dura', 'https://m.media-amazon.com/images/I/81UMBcGdzsL.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('0qYJEAAAQBAJ', 'Historia de España sin mitos ni tópicos', '', 'B DE BOLSILLO', '978-8413142395', 'es', 480, '2021-01-28', 'Un recorrido didáctico y rico por losgrandes hechos y personajes que marcaron la historia de España.\r\n\r\nLos mitos han perseguido a España desde que Escipión Emiliano sitió Numancia. Durante los siguientes siglos se han esgrimido una retahíla de falacias sobre este país que, a golpe de repetirse, han forjado la llamada Leyenda Negra. Este libro se enfrenta a todas ellas. Desde la idea de que la brutalidad campó a sus anchas a partir del siglo XVI, hasta la que muestra a los conquistadores como bárbaros sedientos de sangre.\r\n\r\nCon la veracidad y el rigor de los datos por estandarte, y bajo la premisa de buscar siempre una divulgación amena, los periodistas César Cervera y Manuel Villatoro abordan en estas páginas las gestas más reconocidas de las tropas españolas a lo largo de dos mil años, las peripecias más llamativas de los monarcas que han dirigido este país o, entre otras muchas cosas, los hitos más destacados de su pasado. Un paseo rico y fascinante para acercarnos un poco más al relato más apasionante de todos: el de nuestra historia.', 'De bolsillo', 'https://m.media-amazon.com/images/I/816U0oXnj5L._SL1500_.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('1pX-AgAAQBAJ', 'Armand el vampiro (Crónicas Vampíricas 6)', '', 'B DE BOLSILLO', '9788490707715', 'es', 528, '2014-08-16', 'En esta sexta entrega de las \"Crónicas Vampíricas\" Anne Rice recupera a un personaje que conocimos en Entrevista con el vampiro: el joven Armand.\r\n\r\nEsta es la historia de Armand, el eterno joven con la cara de un ángel de Boticelli. Acompañemosle por su biografía a traves de los siglos, desde el Kiev de su infancia hasta Venecia, pasando por la antigua Constantinopla.\r\n\r\n\"No existe ningún vínculo telepático natural entre nosotros: Marius me creó, yo soy su eterno discípulo. No obstante, en cuanto me ocurrió esto, comprendí que sin la ayuda de ese vínculo telepático no podía sentir la presencia de Marius en el edificio. No sabía lo que había sucedido durante el breve intervalo en que me arrodille para contemplar a Lestat . No sabía dónde se encontraba Marius. No percibí los olores humanos de Benji y Sybelle que me eran tan familiares. Sentí una punzada de pánico que me paralizó.\"', 'De bolsillo', 'https://imagessl5.casadellibro.com/a/l/s7/15/9788490707715.webp', 10, 0, '2025-04-02', '2025-06-03'),
('2rA8AwAAQBAJ', 'Fullmetal Alchemist, Vol. 15', '', 'VIZ Media LLC', '9781421513805', 'en', 192, '2007-12-18', 'In an alchemical ritual gone wrong, Edward Elric lost his arm and his leg, and his brother Alphonse became nothing but a soul in a suit of armor. Equipped with mechanical “auto-mail” limbs, Edward becomes a state alchemist, seeking the one thing that can restore his and his brother’s bodies...the legendary Philosopher’s Stone.\r\n\r\nThe horrors of the Ishbalan campaign occurred years before Ed became a state alchemist, and had serious repercussions, which set the tone for the complicated dealings of present-day state politics. Lieutenant Hawkeye reluctantly tells Ed all the dread details of the role Colonel Mustang and the other state alchemists played in this tragic event.', 'Tapa blanda', 'https://m.media-amazon.com/images/I/71FBP6mEW6L._SL1500_.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('3jjIEAAAQ54L', 'The Murder on the Links', NULL, 'Warbler Classics', '9781734452556', 'en', 199, '2020-01-10', 'When Hercule Poirot and his associate Arthur Hastings arrive in the French village of Merlinville-sur-Mer to meet their client Paul Renauld, they learn from the police that he has been found that morning stabbed in the back with a letter opener and left in a newly-dug grave adjacent to a local golf course.\r\n\r\nAmong the plausible suspects are Renauld\'s wife Eloise, his son Jack, Renauld\'s immediate neighbor Madame Daubreuil, the mysterious \"Cinderella\" of Hasting\'s recent acquaintance, and some unknown visitor of the previous day--all of whom Poirot has reason to suspect. Poirot\'s powers of investigation ultimately triumph over the wiles of an assailant whose misdirection and motives are nearly--but not quite--impossible to spot.\r\n\r\nContains a character key, a detailed biography, and an illustrated list of notable Poirot portrayals.', 'Tapa blanda', 'https://m.media-amazon.com/images/I/617YFrhVlSL._AC_UF1000,1000_QL80_.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('3jjIEAAAQBAJ', 'Asesinato en el campo de golf', '', 'Espasa', '9788467070613', 'es', 256, '2023-07-12', 'Un nuevo reto para las células grises de Hércules Poirot. ¿Una muerte que habría podido evitar?\r\n\r\nHércules Poirot recibe una carta de Paul Renauld, quien le dice que teme por su vida y le urge a que acuda en su ayuda. Así, junto con su amigo el capitán Hastings, el detective se dirige rápido al norte de Francia para prestar sus servicios al nuevo cliente. Sin embargo, llegan demasiado tarde: el cuerpo de Renauld yace apuñalado en medio de un campo de golf.\r\n\r\nMientras Poirot investiga la escena del crimen y a los posibles sospechosos, descubre otro cuerpo asesinado de la misma manera que el primero, y con la misma arma. ¿Qué tienen en común estos hombres? ¿Quién los ha matado? ¿Y por qué Poirot no deja de pensar en un crimen cometido años atrás?', 'Tapa blanda', 'https://imagessl0.casadellibro.com/a/l/s7/50/9788467070750.webp', 10, 0, '2025-04-02', '2025-06-03'),
('49aCDwAAQBAJ', 'Poesía completa (edición bilingüe)', '', 'Penguin Clásicos', '9788491054023', 'en', 424, '2019-02-21', 'Los poemas completos de Catulo en edición bilingüe y en una nueva traducción de Ramón Irigoyen.\r\n\r\nEl presente volumen recoge la obra completa de Catulo, quizá el poeta latino que resuena con mayor fuerza en nuestra epoca de contrastes, pasiones y divisiones. Tres son los grupos en que puede dividirse esa obra: los poemas brevesque el consideraba diversiones formales y hablaban de temas como la política, la amistad o sus pequeñas perversiones; los poemas largos y eruditos, inspirados en temas mitológicos; y, finalmente, los epigramas acerca de temas de la vida cotidiana.\r\n\r\nLa magnífica versión de Ramón Irigoyen acerca al lector al amor y al odio visceral de Catulo, pero tambien a la alegría, la desesperación sexual, la tristeza terrible y el humor sublime que alberga el refinamiento de suinteligencia, con el más exquisito perfeccionismo formal. ¿Cuántos millones de carcajadas y de sonrisas le ha debido el mundo occidental en los últimos veinte siglos a Cátulo?', 'Tapa blanda', 'https://imagessl3.casadellibro.com/a/l/s7/23/9788491054023.webp', 10, 0, '2025-04-02', '2025-04-02'),
('6dwVtgEACAAJ', 'Lazarillo de Tormes', '', 'Austral', '9788467052282', 'es', 144, '2018-05-24', 'El autor del Lazarillo de Tormes compuso una obra entretenida pero con una lúcida mirada crítica hacia la sociedad. Bajo la forma epistolar, y por petición de Vuestra Merced, el personaje de Lázaro nos relata una autobiografía sesgada que se inicia con su nacimiento en el río Tormes, se centra en las vivencias con amos poco ejemplares y finaliza en la edad adulta, cuando se halla «en la cumbre de toda buena fortuna», momento en que conocemos el «caso muy por extenso». La genialidad de su creador radica en que nos hace cómplices a los lectores y creemos que el contenido que se ofrece en la narración es cierto, verosímil, de ahí que se la pueda considerar el germen de la novela moderna, que más tarde culminará su mayor representante, Miguel de Cervantes.\r\n\r\nLa presente edición ofrece a los alumnos una aproximación amena, sugerente y rigurosa a una de las obras más representativas de la narrativa española del Siglo de Oro. El estudio introductorio, los textos críticos escogidos y el conjunto de las diferentes actividades propuestas pretenden guiar al estudiante en la lectura y comprensión de esta obra fundamental del Renacimiento.', 'De bolsillo', 'https://imagessl2.casadellibro.com/a/l/s7/82/9788467052282.webp', 10, 0, '2025-04-02', '2025-05-25'),
('8hfwCwAAQBAJ', 'Alicia en el país de las maravillas | A través del espejo | La caza del Snark', '', 'Penguin Clásicos', '9788491052258', 'es', 400, '2016-05-19', 'Una obra maestra de la literatura infantil que es tambien un sensacional asalto a la lógica de los adultos.\r\n\r\nEdición y traducción de Luis Maristany\r\n\r\nMaestro del sinsentido literario, Lewis Carroll traspasó en estos textos el umbral que separa la realidad del sueño y se adentró en un territorio sin leyes ni normas donde todo es posible. Alicia, los estrambóticos personajes del País de las Maravillas, los del otro lado del espejo y los pertenecientes a la tripulación en batida contra el Snark ponen así en entredicho todos y cada uno de los postulados lógicos en los que se basa el mundo en que vivimos.\r\n\r\nAcompañado de las ilustraciones originales de John Tenniel, el presente volumen recoge las formidables traducciones de Luis Maristany, uno de los más consagrados expertos en la obra de Carroll que ha habido en nuestra lengua. A modo de apendice, además, se incluye una selección de cartas del autor y un pormenorizado estudio de Nina Auerbach, catedrática emerita en la Universidad de Pennsylvania y reconocida especialista en literatura inglesa decimonónica.\r\n\r\nLa opinión de celebres autores:\"Sólo Lewis Carroll nos ha mostrado el mundo tal y como un niño lo ve, y nos ha hecho reír tal y como un niño lo hace\".Virginia Woolf', 'De bolsillo', 'https://imagessl8.casadellibro.com/a/l/s7/58/9788491052258.webp', 10, 0, '2025-04-02', '2025-06-03'),
('8jFVDgAAQBAJ', 'Culpa mía (Culpables 1)', '', 'MONTENA', '9788413142012', 'es', 448, '2017-06-08', 'Nicholas Leister ha sido creado para amargarme la vida. Alto, ojos azules, pelo negro como la noche... Suena genial ¿verdad? Pues no tanto cuando te enteras de que va a ser tu hermanastro y además representa todo de lo que has estado huyendo desde que tienes uso de razón.\r\n\r\nPeligro fue lo primero que me vino a la cabeza cuando lo conocí y descubrí que mantiene una doble vida oculta de su padre multimillonario.\r\n\r\n¿Cómo terminé cayendo en sus redes? Fácil: con esos ojos es capaz de poner tu mundo patas arriba.', 'De bolsillo', 'https://m.media-amazon.com/images/I/81CN6TIFDES.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('910-AwAAQBAJ', 'Fullmetal Alchemist, Vol. 16', '', 'VIZ Media LLC', '9781421513812', 'en', 192, '2008-03-18', 'Breaking the laws of nature is a serious crime!\r\n\r\nIn an alchemical ritual gone wrong, Edward Elric lost his arm and his leg, and his brother Alphonse became nothing but a soul in a suit of armor. Equipped with mechanical “auto-mail” limbs, Edward becomes a state alchemist, seeking the one thing that can restore his and his brother’s bodies...the legendary Philosopher’s Stone.\r\n\r\nThe brothers pursue fugitive May Chang to solve the mystery of why their alchemical powers were rendered inert while she and Scar continued to be able to wield them. Meanwhile, Scar enlists some unlikely help to delve into the secrets of his brother\'s alchemical knowledge. And the newest, most horrifying homunculus makes an appearance...!', 'Tapa blanda', 'https://m.media-amazon.com/images/I/81nvD+Us8jL._SL1500_.jpg', 10, 0, '2025-04-02', '2025-04-27'),
('94D_CgAAQBAJ', 'Tragedias (Obra completa Shakespeare 2)', '', 'Penguin Clásicos', '9788491051350', 'es', 1200, '2016-01-07', 'Las tragedias de Shakespeare representan una de las cumbres de la literatura universal. Su grandeza radica en una mirada visionaria de la condición humana, en la honestidad al mostrar las pasiones más oscuras, en su forma de tratar el amor, la muerte, el destino, los lazos familiares, la locura, la amistad o el afán de poder. En ellas se trazan complejos laberintos de emoción y reflexión que han convertido a sus personajes en arquetipos literarios: de Hamlet a Lear, de Macbeth a Yago, de Ofelia a Lady Macbeth.\r\n\r\nTragedias es el segundo volumen de una colección de cinco que reúne la obra completa de Shakespeare. Aquí se incluyen Tito Andrónico, Romeo y Julieta, Julio Cesar, Hamlet, Otelo, El rey Lear, Macbeth , Antonio y Cleopatra, Timón de Atenas y Coriolano. ', 'De bolsillo', 'https://imagessl0.casadellibro.com/a/l/s7/50/9788491051350.webp', 10, 0, '2025-04-02', '2025-05-29'),
('9XBdtQW57NQC', 'Son de Mar', '', 'DEBOLS!ILLO', '9788466333443', 'es', 280, '2016-04-14', 'Todos los muertos vuelven si los llama el amante con la fuerza necesaria.\r\n\r\nEl protagonista de esta novela es un náufrago que regresa despues de diez años y, a pesar de que su mujer ya había rehecho su vida, ambos vuelven a sentir el amor y la pasión que creyeron perdidos.\r\n\r\nPero este hecho sucede tambien cada día en el asfalto de la ciudad. Según el manual de la resurrección, el primer requisito que se exige para resucitar es estar vivo, aunque la vida te sumerja cada día en la profundidad de los mares. En este caso siempre habrá algún amante que te llame desde cualquier orilla y tú tendrás la necesidad de volver a ella.', 'De bolsillo', 'https://imagessl3.casadellibro.com/a/l/s7/43/9788466333443.webp', 10, 0, '2025-04-02', '2025-06-01'),
('A2HcEAAAQBAJ', 'Asesinato en el Orient Express', '', 'Espasa', '9788467045413', 'es', 248, '2015-09-15', 'Un referente universal. Uno de los casos más famosos de Hércules Poirot.\r\nLa novela más popular del mítico detective Hércules Poirot.\r\n\r\nEn un lugar aislado de la antigua Yugoslavia, en plena madrugada, una fuerte tormenta de nieve obstaculiza la línea férrea por donde circula el Orient Express. Procedente de la exótica Estambul, en él viaja el detective Hércules Poirot, que repentinamente se topa con uno de los casos más desconcertantes de su carrera: en el compartimiento vecino ha sido asesinado Samuel E. Ratchett mientras dormía, pese a que ningún indicio trasluce un móvil concreto. Poirot aprovechará la situación para indagar entre los ocupantes del vagón, que a todas luces deberían ser los únicos posibles autores del crimen.', 'Tapa blanda', 'https://imagessl3.casadellibro.com/a/l/s7/13/9788467045413.webp', 10, 0, '2025-04-02', '2025-05-29'),
('A8oVEQAAQBAJ', 'La revolución del movimiento', 'Libera tus pies, desata tus límites, conquista tu salud', 'Bruguera', '9788402430175', 'es', 256, '2024-09-26', 'Tu salud empieza por los pies.\r\n\r\nInicia tu camino hacia una vida saludable y conquista tu salud de la mano de Rubens García, coach de movimiento funcional especializado en rehabilitación y neuromecánica.\r\n\r\nPese a todos los avances en el ámbito de la salud y a la cantidad de descubrimientos sobre el cuerpo humano, vivimos más desconectados de el que nunca. Lo sometemos a jornadas sedentarias que van en contra de nuestra naturaleza, no lo usamos para lo que está diseñado y solo lo escuchamos cuando nos lesionamos o enfermamos.\r\n\r\nPero ¿y si te dijera que tú tienes la llave para acabar con gran parte del malestar que te genera la vida moderna? Tras años de experiencia como especialista en rehabilitación y neurobiomecánica, en este libro te invito a descubrir las bases del movimiento funcional y su poder terapeutico. Restaura la movilidad natural de tu cuerpo empezando por los pies y empieza a vivir mejor ya.\r\n\r\nBienvenido a la revolución del movimiento: es hora de descubrir tu máximo potencial paso a paso.', 'Tapa blanda', 'https://imagessl0.casadellibro.com/a/l/s7/80/9788402429780.webp', 10, 0, '2025-04-02', '2025-04-02'),
('aKz6EAAAQBAJ', 'La voz de los libros', 'Una historia de la lectura, desde los escribas hasta los audiolibros', 'Aguilar', '9788403523739', 'es', 416, '2024-05-16', 'Una historia de la lectura, desde los escribas hasta los audiolibros.\r\n\r\nSi miramos con perspectiva nuestra historia, de los más de 120.000 años que tiene nuestra especie, la escritura existe desde hace solo cinco mil. Leer es algo muy nuevo. Mucho más aún lo es la lectura individual y en silencio. Antes de leer como lo estás haciendo ahora mismo, la literatura era un acto social y se leía para otros, y no solo eso, sino que en el Renacimento llegó a existir la figura de \"Lector de su Majestad\". Obras como El Quijote, La Celestina o El Lazarillo de Tormes llegaron al pueblo gracias a las declamaciones que se realizaban en las calles y este tipo de lectura sería clave tambien en el progreso de las ideas revolucionarias entre los franceses del siglo XVII. La lectura en voz alta llegó a ser un acto popular en las reuniones sociales del siglo XIX y, a pesar de haber cambiado nuestro modo de leer, ha pervivido de un modo u otro hasta nuestros días.\r\n\r\n¿Por que se leía en voz alta?¿Cuándo y por que pasamos a hacerlo en silencio? ¿Tiene sentido leer en alto en el s.XXI? ¿Cómo han aprendido a leer las máquinas y cómo leeremos en el futuro?. Maribel Riaza intenta dar respuesta a todas estas preguntas en este libro ameno, divulgativo y lleno de curiosidades que nos lleva a conocer mejor cómo eran los lectores que nos han precedido y cómo se ha disfrutado de la literatura a través de este noble arte de leer.', 'Tapa blanda', 'https://imagessl9.casadellibro.com/a/l/s7/39/9788403523739.webp', 10, 0, '2025-04-02', '2025-05-04'),
('B0bvNwAACAAJ', 'Pingüino', '', 'RBA Libros', '9788479018597', 'es', 32, '2008-01-01', 'Cuando Ben abre su regalo de cumpleaños encuentra dentro un Pingüino. \'Hola, Pingüino\' le dice. \'¿A qué jugamos?\' Pero el Pingüino no responde. Ben hace de todo para intentar que hable: baila, hace la vertical, saca la lengua, le pone su gorro más raro y poco a poco radicaliza sus tácticas. Pero el Pingüino no responde. ¿Cuanto tiempo va a tardar el misterioso animal en decir algo? ¿O cuanto tiempo va a tardar Ben en entender lo que el Pingüino tiene que decir? Las ilustraciones frescas y sencillas propias de Polly Dunbar dotan de elocuencia a este magnífico cuento en el que un Pingüino mudo se vuelve maravillosamente locuaz, y un niño pequeño finalmente consigue lo que quiere. También se dará cuenta de que valió la pena la espera.', 'Tapa dura', 'https://m.media-amazon.com/images/I/61RMETs9VNL._SL1500_.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('bsYtDwAAQBAJ', 'Viaje al centro de la Tierra', '', 'Austral', '9788467050660', 'es', 576, '2017-10-17', 'Cubierta diseñada por Pete Lloyd. Traducción de Trinidad García del Cid.\r\n\r\nEl profesor Liddenbrock descubre en un manuscrito antiguo una pista que lo llevará a un pasadizo en el interior de un volcán islandés.', 'Tapa dura', 'https://imagessl0.casadellibro.com/a/l/s7/60/9788467050660.webp', 5, 0, '2025-04-02', '2025-06-03'),
('B_XDEAAAQBAJ', 'Amor, te odio', '', 'B DE BOLSILLO', '9788413146744', 'es', 328, '2023-07-06', '¿QUÉ PASA CUANDO CIERTOS SECRETOS SALEN A LA LUZ?\r\n\r\nUNA VIDA APARENTEMENTE PERFECTA QUE, EN REALIDAD... ES UNA MENTIRA.\r\n\r\nEmbárcate en el último vuelo de la serie A bordo.\r\n\r\nPaola es una mujer sensual, fuerte y decidida que trabaja como azafata de vuelo.\r\n\r\nÉl se cruza en su camino por casualidad, pero no una, sino varias veces.\r\n\r\n¿Que haces cuando tus opciones son un mentiroso o un mujeriego?\r\n\r\nAcompañada de sus dos mejores amigas, Paola cree que no tiene nada más que desear. Pero en realidad, está a punto de descubrir que no todo es lo que parece. Y sin darse cuenta, terminará sucumbiendo al encanto de la persona que menos se esperaba: ambos acabarán sumidos en una relación de alto voltaje que arrasará con todo en su camino.\r\n\r\nEn Amor, te odio se dan cita viajes, aventuras, mentiras, secretos, peleas, celos, dramas familiares, amigas locas, diversión, lujo y mucho mucho sexo.', 'De bolsillo', 'https://imagessl4.casadellibro.com/a/l/s7/44/9788413146744.webp', 10, 0, '2025-04-02', '2025-04-02'),
('cqahDAAAQBAJ', 'Cuentos completos (Los mejores clásicos)', '', 'Penguin Clásicos', '9788491052326', 'es', 1024, '2016-09-22', 'El mal, el misterio, el amor, el mar, el viaje, las aventuras... todos los grandes temas de Robert Louis Stevenson se reúnen en esta preciosa edición ilustrada de sus Cuentos completos de la colección Grandes Clásicos de Literatura Random House.\r\n\r\n\"Hay muchas razones por las que no debería contarles mi historia. Tal vez por eso mismo vaya a hacerlo.\"\r\n\r\nSe reúnen en este volumen, por primera vez en castellano, todos los relatos del gran Stevenson, un escritor que ha encantado a sucesivas generaciones de lectores desde finales del siglo XIX hasta nuestros días. Estos cuentos conforman uno de los universos literarios más ricos y mágicos de la literatura universal. Aquí nos encontramos con historias tan populares como El extraño caso del doctor Jekyll y Mr. Hyde, además de otras obras maestras igualmente inolvidables.\r\n\r\nYa sean historias fantásticas, románticas o de ambiente marino, los cuentos de Stevenson constituyen una lectura insustituible, un placer en esta edición renovada, gracias sobre todo a la esplendida traducción de Miguel Temprano García y a las ilustraciones de Alexander Jansson.', 'De bolsillo', 'https://imagessl6.casadellibro.com/a/l/s7/26/9788491052326.webp', 10, 0, '2025-04-02', '2025-04-02'),
('E5pBEAAAQBAJ', 'Chispas', '', 'ALFAGUARA', '9788420459875', 'es', 128, '2021-10-21', 'Una pertida e ingeniosa alegoría del mundo moderno escrita por Manuel Rivas, una de las grandes plumas de la literatura española y Premio Nacional de las Letras Españolas 2024.\r\n\r\nChispas es músico. A el le gustaría ser un artista cósmico, pero la gente de su pueblo, Entrelampo, lo considera más bien un cómico. Un cómico no demasiado bueno, además. Hasta el día que la Fuente del Habla convierte sus canciones en mágicas y a Chispas en una estrella del rock. Solo que… no en nuestro mundo, sino en el lejano planeta Mutandi, gobernado por los Cracks, unos seres cuya realidad se rige por modas. Y ahora, la nueva moda es Chispas. ¡Un músico cósmico!', 'Tapa dura', 'https://imagessl5.casadellibro.com/a/l/s7/75/9788420459875.webp', 10, 0, '2025-04-02', '2025-04-02'),
('Eas4AwAAQBAJ', 'El santuario (Crónicas Vampíricas 9)', '', 'B DE BOLSILLO', '9788490707746', 'es', 688, '2019-02-21', 'Del Nueva Orleans actual al Nápoles del siglo XIX, pasando por la antigua Atenas o Pompeya, la intensa trayectoria vital del vampiro Quinn reúne en un mismo volumen las \"Crónicas Vampíricas\" y la serie de \"Las Brujas de Mayfair\" para revelar otros episodios de la historia de los vampiros.\r\n\r\nQuinn Blackwood, un rico y excentrico joven convertido en vampiro, pide la ayuda de Lestat para librarse del celoso control a que le somete Goblin, su doppelgänger. Desde que Quinn entró en el reino de los muertos, Goblin, otrora su sombra fiel, se ha convertido en una amenaza para los seres cercanos al atractivo gentleman.\r\n\r\nLestat, intrigado, le pide a Quinn que narre la historia de su vida. Este recuerda su infancia en el seno de una familia muy peculiar y describe sus días en Blackwood Farm, la mansión de altas columnas y extensos jardines rodeada de zonas pantanosas en la que creció y ahora reside. A pesar de su amor por Mona Mayfair, una bella bruja con la que mantiene una apasionada relación, Quinn posee una agitada vida amorosa que, junto a su imperioso deseo de beber sangre, le ha llevado a recorrer el mundo y conocer distintas epocas de la historia.', 'De bolsillo', 'https://imagessl6.casadellibro.com/a/l/s7/46/9788490707746.webp', 10, 0, '2025-04-02', '2025-04-02'),
('FdQ-EQAAQBAJ', 'THE AMAZING SPIDER-MAN', '', 'Penguin Classics USA', '9780143135722', 'en', 384, '2022-06-14', 'The Penguin Classics Marvel Collection presents the origin stories, seminal tales, and characters of the Marvel Universe to explore Marvel s transformative and timeless influence on an entire genre of fantasy.   A Penguin Classics Marvel Collection Edition   Collects Spider-Man! from Amazing Fantasy #15 (1962); The Amazing Spider-Man #1-4, #9, #10, #13, #14, #17-19 (1963-1964); Goodbye to Linda Brown from Strange Tales #97 (1962); How Stan Lee and Steve Ditko Create Spider-Man! from The Amazing Spider-Man Annual #1 (1964). It is impossible to imagine American popular culture without Marvel Comics. For decades, Marvel has published groundbreaking visual narratives that sustain attention on multiple levels: as metaphors for the experience of difference and otherness; as meditations on the fluid nature of identity; and as high-water marks in the artistic tradition of American cartooning, to name a few.   This anthology contains twelve key stories from the first two years of Spider-Man s publication history (from 1962 to 1964). These influential adventures not only transformed the super hero fantasy into an allegory for the pain of adolescence but also brought a new ethical complexity to the genre by insisting that with great power there must also come great responsibility.   A foreword by Jason Reynolds and scholarly introductions and apparatus by Ben Saunders offer further insight into the enduring significance of The Amazing Spider-Man and classic Marvel comics.   The Deluxe Hardcover edition features gold foil stamping, gold top stain edges, special endpapers with artwork spotlighting series villains, and full-color art throughout.', 'Tapa dura', 'https://m.media-amazon.com/images/I/81U6GlLBxtL._AC_UF1000,1000_QL80_.jpg', 5, 0, '2025-04-02', '2025-06-03'),
('FfsVCgAAQBAJ', 'El séptimo hijo (Alvin Maker [El Hacedor] 1)', '', 'B DE BOLSILLO', '9788490194683', 'es', 400, '2015-01-01', 'En una Norteamerica vasalla todavía de la corona británica, donde la magia y los conjuros folclóricos son tan efectivos entre el hombre blanco como entre los pieles rojas...\r\n\r\nAlvin ha nacido en el seno de una familia de colonos que se dirige al oeste.\r\n\r\nEs el septimo hijo varón de un septimo hijo varón y, por las prodigiosas circunstancias de su nacimiento, está llamado a ser un Hacedor: un antagonista de los poderes innominables que persiguen la destrucción de todo lo creado. De ahí las facultades mágicas con las que ha sido dotado, y las fuerzas que desde un principio conspiran contra el.\r\n\r\nAlvin solo logrará sobrevivir si aprende a dominar sus poderes y supera las influencias maleficas que quieren darle muerte.', 'Tapa blanda', 'https://imagessl0.casadellibro.com/a/l/s7/90/9788490709290.webp', 10, 0, '2025-04-02', '2025-04-02'),
('FqEkEQAAQBAJ', 'INCAL FINAL INTEGRAL', '', 'Reservoir Books', '9788418897559', 'es', 228, '2022-11-03', 'Llegamos a los confines del Jodoverso: el cierre de la mayor saga del cómic de ciencia ficción, en una edición integral inédita en español.\r\n\r\nEl antiheroico detective John Difool ha roto el bucle de su caída eterna, pero ahora debe enfrentarse a otra misión para salvar al universo, amenazado por un virus robótico que quiere terminar con toda materia viva. Dotado de un insólito don de la ubicuidad, Difool se va a multiplicar en cuatro individuos distintos y por la misma razón idénticos, desempeñando un nuevo rol: el de héroe múltiple, mutable y voluntariamente contradictorio.', 'Tapa dura', 'https://m.media-amazon.com/images/I/81h9km9d+hL._SL1500_.jpg', 8, 0, '2025-04-02', '2025-04-02'),
('Frh-CgAAQBAJ', 'Pride and Prejudice (Penguin Clothbound Classics)', '', 'Penguin Classics', '9780141040349', 'en', 480, '2009-10-27', 'Jane Austen’s timeless classic that explores the intricate complexities of love, societal expectations, and the power of overcoming prejudice—now in a beautiful clothbound hardcover edition designed by Coralie Bickford-Smith.\r\n \r\nWhen Elizabeth Bennet first meets eligible bachelor Fitzwilliam Darcy, she thinks him arrogant and conceited; he is indifferent to her good looks and lively mind. When she later discovers that Darcy has involved himself in the troubled relationship between his friend Bingley and her beloved sister Jane, she is determined to dislike him more than ever. In the sparkling comedy of manners that follows, Jane Austen shows the folly of judging by first impressions and superbly evokes the friendships, gossip, and snobberies of provincial middle-class life.\r\n\r\nPenguin Classics is the leading publisher of classic literature in the English-speaking world, representing a global bookshelf of the best works throughout history and across genres and disciplines. Readers trust the series to provide authoritative texts enhanced by introductions and notes by distinguished scholars and contemporary authors, as well as up-to-date translations by award-winning translators.', 'Tapa dura', 'https://m.media-amazon.com/images/I/71iiATs-RVL._SL1500_.jpg', 8, 0, '2025-04-02', '2025-05-25'),
('G-TJtAEACAAJ', 'Ángeles y Demonios', '', 'Editorial Planeta', '9788408176008', 'es', 688, '2017-08-29', 'El mayor enemigo de la Iglesia amenaza con destruirla desde sus cimientos.\r\nRobert Langdon, experto en simbología, es convocado a un centro de investigación suizo para analizar un misterioso signo marcado a fuego en el pecho de un físico asesinado. Allí, Langdon descubre el resurgimiento de una antigua hermandad secreta: los illuminati, que han emergido de las sombras para llevar a cabo la fase final de una legendaria venganza contra su enemigo más odiado: la Iglesia católica.Los peores temores de Langdon se confirman cuando los illuminati anuncian que han escondido una bomba en el corazón de la Ciudad del Vaticano. Con la cuenta atrás en marcha, Langdon viaja a Roma para unir fuerzas con Vittoria Vetra, una bella y misteriosa científica. Los dos se embarcarán en una desesperada carrera contrarreloj por los rincones menos conocidos del Vaticano.Ángeles y demonios, la primera aventura del carismático e inolvidable Robert Langdon, es un adictivo y trepidantethriller sobre la eterna pugna entre ciencia y religión. Esta lucha se convierte en una verdadera guerra que pondrá en jaque a toda la humanidad, que deberá luchar hasta el último minuto para evitar un gran desastre.', 'Tapa blanda', 'https://imagessl8.casadellibro.com/a/l/s7/08/9788408176008.webp', 1, 9, '2025-04-02', '2025-06-02'),
('gdhJEAAAQBAJ', 'Citónica (Escuadrón 3)', '', 'NOVA', '9788418037191', 'es', 456, '2021-12-02', 'La vida de Spensa como miembro de la Fuerza de Defensa Desafiante dista mucho de ser normal y corriente. Demostró ser una de las mejores pilotos de caza estelar en el enclave humano de Detritus y salvó a su pueblo del exterminio a manos de los krells, la enigmática especie alienígena que los tenía prisioneros desde hace décadas. Por si fuera poco, viajó a años-luz de distancia de su hogar como espía infiltrada en la Supremacía, a un lugar donde descubrió que había toda una galaxia más allá de su pequeño y desolado planeta natal.\r\n\r\nAhora la Supremacía, el gobierno galáctico empecinado en dominar toda vida humana, ha desatado una guerra a escala galáctica. Y Spensa ha visto las armas que pretenden emplear para terminarla: los zapadores, unas antiguas y enigmáticas fuerzas alienígenas que pueden arrasar sistemas estelares enteros en un instante. Spensa sabe que, por muchos pilotos con los que cuente la FDD, no hay manera de derrotar a ese depredador.\r\n\r\nSin embargo, Spensa es citónica. Se enfrentó a un zapador y percibió algo siniestramente familiar en él. Y quizá, si logra descubrir lo que es ella misma, podría ser algo más que solo otra piloto en la guerra. Podría salvar la galaxia.\r\n\r\nPero la única manera de que Spensa descubra su verdadera naturaleza es dejar atrás todo lo que conoce y entrar en la ninguna-parte, un lugar del que muy pocos han regresado jamás.', 'Tapa blanda', 'https://imagessl1.casadellibro.com/a/l/s7/91/9788418037191.webp', 10, 0, '2025-04-02', '2025-05-23'),
('GGaREAAAQBAJ', 'Volver la vista atrás', '', 'ALFAGUARA', '9788420455600', 'es', 480, '2021-02-18', 'Ganador del Premio Bienal de Novela Vargas Llosa 2021\r\n\r\n«Pensó que los recuerdos eran invisibles como la luz, y así como el humo hacía que la luz se viera, debía haber una forma de que fueran visibles los recuerdos.»\r\n\r\nEn octubre de 2016, el director de cine colombiano Sergio Cabrera asiste en Barcelona a una retrospectiva de sus películas. Es un momento difícil: su padre, Fausto Cabrera, acaba de morir; su matrimonio está en crisis, y su país ha rechazado unos acuerdos de paz que le habrían permitido terminar con más de cincuenta años de guerra.\r\n\r\nA lo largo de unos días reveladores, Sergio irá recordando los hechos que marcaron su vida y la de su padre. De la guerra civil española al exilio en América de su familia republicana, de la China de la Revolución Cultural a los movimientos armados de los años sesenta, el lector asistirá a una vida que es mucho más que una gran aventura: es una imagen de medio siglo de historia que trastornó al mundo entero. \r\n\r\nVolver la vista atrás cuenta hechos reales, pero sólo en manos de un novelista magistral como Vásquez podía convertirse en este retrato devastador de una familia arrastrada por las fuerzas de la historia. Una fascinante investigación social y a la vez íntima, política y a la vez privada, que el lector no olvidará.', 'Tapa blanda', 'https://imagessl0.casadellibro.com/a/l/s7/00/9788420455600.webp', 10, 0, '2025-04-02', '2025-04-02'),
('GkIXEQAAQBAJ', 'Una vida infinita', 'Descubre en profundidad el revelador viaje del alma tras la muerte', 'VERGARA', '9788419820655', 'es', 256, '2024-10-10', 'Entender la muerte para entender la vida. Este es el objetivo.\r\n\r\nDe un modo sencillo, pero profundo, este libro nos habla del viaje completo que realizamos tras la muerte, explicando detalladamente cómo es nuestra vida en el mundo espiritual y la influencia que ella tiene en nuestra actual vida en la Tierra. Gracias a este conocimiento, encontramos respuestas a las cuestiones que siempre nos hemos planteado: ¿Dónde vamos tras la muerte? ¿A que hemos venido? ¿Que sentido tiene esta vida? ¿Por que me suceden siempre las mismas cosas? ¿De que manera pueden comunicarse los espíritus con sus seres queridos?\r\n\r\nBasada en las investigaciones más relevantes y con ejemplos reales que el autor ha recogido a traves de las regresiones de sus pacientes, esta obra nos acerca a la autentica realidad de la vida tras la muerte sin ningún tipo de influencia religiosa o filosófica. Además, el autor aborda tambien dos temas estrechamente relacionados con el fallecimiento: el acompañamiento a personas moribundas y el proceso de duelo examinados desde una perspectiva psicoespiritual.', 'Tapa blanda', 'https://imagessl5.casadellibro.com/a/l/s7/55/9788419820655.webp', 10, 0, '2025-04-02', '2025-04-02'),
('GRHAEAAAQBAJ', 'Wendolin Kramer', '', 'DEBOLS!LLO', '9788466371551', 'es', 272, '2023-06-08', 'Recuperamos esta novela de culto de 2013, con la que Laura Fernández llegó por primera vez al gran público\r\n\r\nCon veintiocho años, pero aún instalada en casa de sus padres, Wendolin Kramer adora los cómics, se cree Súper Chica y, desde un despacho improvisado en su cuarto, fantasea con convertirse en detective privado por las calles de una Barcelona fantasmal. Todo cambia cuando llama a su puerta un caso real, que, sin embargo, no le queda muy claro. ¿Por que le piden que averigüe dónde se encuentra un día preciso el escritor Francis Dómino? ¿Y que relación existe entre el y la autora superventas Vendolin Woolfin? Parodia de novela negra, con innumerables referencias a la cultura pop, esta historia no solo ha consagrado a Laura Fernández como una de las voces más originales de nuestras letras, sino que sigue fascinando con sus personajes impredecibles, sus diálogos desternillantes y su inagotable imaginación narrativa.', 'De bolsillo', 'https://imagessl1.casadellibro.com/a/l/s7/51/9788466371551.webp', 10, 0, '2025-04-02', '2025-05-08'),
('HAuSDwAAQBAJ', 'La guerra de los mundos', '', 'Penguin Clásicos', '9788491052371', 'es', 224, '2016-09-22', 'La guerra de los mundos narra por primera vez en la historia de la literatura un tema que será recurrente desde entonces y originará todo un subgénero dentro de la ciencia ficción: la invasión de la Tierra por extraterrestres procedentes de Marte. A través de esta fábula en la que ocupan un lugar central las descripciones científicas, las premoniciones sobre el futuro de la tecnología y los entresijos de la política, H. G. Wells nos habla sobre la vanidad y la seguridad ficticia de una humanidad autosatisfecha, y los peligros que acechan su supervivencia.\r\n\r\nLa obra de Wells ha influido largamente a la tradición literaria de la ciencia ficción. Su presencia ineludible se descubre así en el imaginario de autores consagrados del género como Félix J. Palma, que firma la introducción que abre la presente edición. Asimismo, recuperamos la clásica traducción que en su día hizo Julio Vacarezza y de la que han disfrutado generaciones enteras.', 'De bolsillo', 'https://imagessl1.casadellibro.com/a/l/s7/71/9788491052371.webp', 10, 0, '2025-04-02', '2025-06-03'),
('HfepCAAAQBAJ', 'Contigo en la distancia', '(Premio Alfaguara de novela 2015)', 'ALFAGUARA', '9788420410432', 'es', 360, '2015-05-26', 'A Vera Sigall y Horacio Infante los une un amor de juventud y su pasión por la literatura. También un lazo misterioso que dos jóvenes, Emilia y Daniel, intentan desentrañar. Sin embargo, este no es el único enigma en sus vidas. Una mañana, Vera Sigall cae por las escaleras de su casa y queda en coma. Al principio, la noción de que su caída no fue un accidente aparece como una sospecha para Daniel. Pero con los días y las semanas, la duda irá creciendo hasta volverse una certeza. Emilia y Daniel se encontrarán en la búsqueda de la verdad acerca del accidente de la mítica escritora pero, sobre todo, en la necesidad de entender sus propios destinos.\r\n\r\nLos laberintos del amor y la mentira y el talento desigual como desafío de una pareja son los grandes temas de esta novela de Carla Guelfenbein, una autora que ha deslumbrado a Coetzee y a miles de lectores en el mundo.', 'Tapa blanda', 'https://imagessl2.casadellibro.com/a/l/s7/32/9788420410432.webp', 10, 0, '2025-04-02', '2025-04-02'),
('hmN4m0y6byAC', 'Mira si yo te querré', 'Premio Alfaguara de novela 2007', 'ALFAGUARA', '9788420471952', 'es', 320, '2007-04-04', 'Ni el tiempo ni el desierto pueden frenar al amor.\r\n\r\nEl hallazgo inesperado de una vieja fotografía hará que Montse Cambra, una doctora de cuarenta y cuatro años, abandone su Barcelona natal para buscar a su primer amor. Comienza así un viaje que la llevará hasta el Sáhara. El afán de supervivencia y la pasión de vivir de un pueblo olvidado en el desierto la ayudarán a descubrir su verdadero destino.\r\n\r\nMira si yo te querré es una historia de amor que se alarga en el tiempo, el retrato de dos épocas y de dos culturas unidas por un secreto, la aventura de una mujer que descubre lo más importante en la soledad del desierto.', 'Tapa blanda', 'https://imagessl2.casadellibro.com/a/l/s7/52/9788420471952.webp', 10, 0, '2025-04-02', '2025-05-04'),
('HUMjEAAAQBAJ', 'El método Kamala', '', 'DEBOLS!LLO', '9788466357630', 'es', 240, '2021-04-08', 'Aprende los hábitos diarios de Kamala Harris para lograr tus metas.\r\n\r\nKamala Harris ha hecho historia. No solo se ha convertido en la primera mujer en ocupar el cargo de vicepresidenta de Estados Unidos, sino que es tambien la primera persona afroamericana en este puesto. Sin embargo, su camino no ha sido fácil y tampoco parece que vaya a acabar aquí. El metodo Kamala nos presenta los cien aspectos decisivos en la vida de Harris: sus hábitos, sus puntos de inflexión, su modo de enfrentarse a los conflictos... Los detalles del día a día son lo que construyen el destino de cada uno, y este libro nos acerca a los de una mujer hecha a sí misma para poder aplicarlos a nuestra vida.', 'De bolsillo', 'https://imagessl0.casadellibro.com/a/l/s7/30/9788466357630.webp', 10, 0, '2025-04-02', '2025-04-02'),
('i8mXDwAAQBAJ', 'Los cuatro grandes', '', 'Espasa', '9788467055993', 'es', 256, '2019-06-11', '¿Podrá Hércules Poirot enfrentarse a los cuatro seres más malvados del planeta?\r\n\r\nHércules Poirot se enfrenta con unos criminales fuera de lo común. No son vulgares asesinos ni simples estafadores. Son líderes organizados a escala internacional que mueven los hilos de cuanto sucede en el mundo. Se los conoce como «Los Cuatro Grandes» y el detective tendrá que descubrir su identidad antes de que sea demasiado tarde para la humanidad. La primera misión de la banda consiste en deshacerse de su principal enemigo: precisamente, Hércules Poirot. El célebre detective es la única persona capaz de adelantarse a los planes urdidos por los cuatro villanos para apoderarse del mundo, y por ello se convierte en blanco de un sinfín de estratagemas destinadas a eliminarlo, a lo largo de una lucha a muerte salpicada de episodios tan sorprendentes como apasionantes.', 'Tapa blanda', 'https://imagessl1.casadellibro.com/a/l/s7/01/9788467056501.webp', 10, 0, '2025-04-02', '2025-04-29'),
('iF0-AwAAQBAJ', 'Fullmetal Alchemist, Vol. 12', '', 'VIZ Media LLC', '9781421508399', 'en', 192, '2007-03-20', 'In an alchemical ritual gone wrong, Edward Elric lost his arm and his leg, and his brother Alphonse became nothing but a soul in a suit of armor. Equipped with mechanical “auto-mail” limbs, Edward becomes a state alchemist, seeking the one thing that can restore his and his brother’s bodies...the legendary Philosopher’s Stone.\r\n\r\nThe hunters become the hunted when the Elric brothers and Prince Lin set a trap for the homunculus with the insatiable appetite--Gluttony! On another front, state politics are shaken up when a horrifying truth about Führer President King Bradley is revealed--and Colonel Roy Mustang is right there to capitalize on the situation.', 'Tapa blanda', 'https://m.media-amazon.com/images/I/81dUTp8-WcL._SL1500_.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('ilPkDwAAQBAJ', 'Tormento', '', 'Austral', '9788408224907', 'es', 400, '2020-06-16', 'Tormento es una de las obras que componen la serie Novelas contemporáneas de Benito Pérez Galdós, que se abre con La desheredada en 1881, puerta de entrada del naturalismo en España. Tormento se publicó en 1884 y trata uno de los temas que más centraron el interés del autor en aquella época: la situación de la clase media venida a menos y, concretamente, cómo la mujer de dicho grupo social se veía abocada a la miseria, a matrimonios más o menos forzados, a convertirse en monja o a menesteres menos honrosos. Esta novela pone además sobre la mesa el diagnóstico del escritor acerca de numerosos aspectos de la sociedad española de la segunda mitad del siglo XIX: la falta de vocación o preparación de ciertos miembros de la Iglesia católica, la hipocresía social, la educación, los vaivenes políticos y la corrupción del sistema de la Restauración borbónica. Para facilitar la comprensión de la novela, la presente edición incluye un apartado de notas, además de un estudio preliminar y propuestas de trabajo, a cargo de la profesora Blanca Ripoll Sintes.', 'De bolsillo', 'https://imagessl7.casadellibro.com/a/l/s7/07/9788408224907.webp', 10, 0, '2025-04-02', '2025-04-27'),
('iQtQPQAACAAJ', 'Arquitectura islámica en Andalucía', '', 'Taschen Benedikt', '9783822821145', 'es', 235, '2002-10-07', 'Andalucía es una tierra en la cual el Islam y la cristiandad se enfrentaron hasta las últimas consecuencias. Una tierra de cruzadas, en la cual el gran inquisidor sucedió al imán, y en la cual el gran inquisidor sucedió al imán, y en la que las procesiones de penitentes atravesaban las calles de los antiguos suqs. Mas a pesar de toda la intolerancia, de todo el odio entre las dos religiones y culturas, se han desarrollado formas de vida comunes que desbordan toda fantasía.', 'Tapa blanda', 'https://m.media-amazon.com/images/I/911M+O+3coL._AC_UF1000,1000_QL80_.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('jgzZEAAAQBAJ', 'ESTELA PLATEADA. PARÁBOLA', '', 'Panini España SA', '9788491679035', 'es', 80, '2019-11-19', 'Stan Lee y Moebius acometen la historia definitiva de Estela Plateada, en un enfrentamiento frontal contra el ser que le dotó de sus poderes cósmicos: Galactus. ¿Qué ocurre cuando el Devorador de Mundos ofrece a la humanidad todo aquello con lo que siempre soñó?', 'Tapa dura', 'https://imagessl5.casadellibro.com/a/l/s7/35/9788491679035.webp', 10, 0, '2025-04-02', '2025-06-01'),
('JW1nEAAAQBAJ', 'Telón', '', 'Espasa', '9788467065640', 'es', 240, '2022-04-06', 'Todo lo que empieza tiene un final: Descubre el último caso del célebre Hércules Poirot.\r\n“Éste, Hastings, será mi último caso. Será también el más interesante de todos.”\r\n\r\nMuchos años atrás, Hércules Poirot resolvió en la mansión Styles un célebre caso, con el que inició su brillante carrera de detective en Inglaterra. Ahora, ya en su ocaso, con problemas de corazón y movilidad, Poirot regresa a Styles y cita allí a su inseparable amigo, el capitán Hastings. El asesino ya ha matado impunemente en cinco ocasiones y, como todos los criminales, se cree más inteligente que nadie. Y eso es algo que Poirot no puede consentir.\r\n\r\nPor última vez, Hércules Poirot, el investigador más célebre de la Historia, deberá llevar hasta el límite sus famosas célebres células grises para desenmascarar al asesino, mientras se da perfecta cuenta de que está ante su último caso.', 'Tapa blanda', 'https://imagessl0.casadellibro.com/a/l/s7/40/9788467065640.webp', 10, 0, '2025-04-02', '2025-05-25'),
('KJZeEAAAQBAJ', 'El sueño de los héroes', '', 'DEBOLS!LLO', '9788466360241', 'es', 240, '2022-03-24', 'La gran novela de Adolfo Bioy Casares sobre una aventura cotidiana que poco a poco va cobrando tintes fantásticos.\r\n\r\nAmbientada en los años treinta en una Buenos Aires fantasmal, El sueño de los heroes parte de la juerga que se dan Emilio Gauna y sus amigos durante tres noches de carnaval por los suburbios de la ciudad. Nada debería ser más mundano, pero al recordarla Gauna se convence de que en la última noche vivió \"una prodigiosa aventura\". Cuando intente repetirla tres años más tarde, el sueño de una revelación se convertirá en un enfrentamiento con su destino.\r\n\r\nDesde su publicación en 1954, este clásico de la literatura argentina no ha dejado de fascinar a los lectores con su intrigante mezcla de lo fantástico y lo cotidiano.', 'De bolsillo', 'https://imagessl1.casadellibro.com/a/l/s7/41/9788466360241.webp', 10, 0, '2025-04-02', '2025-05-09');
INSERT INTO `libros` (`id`, `titulo`, `subtitulo`, `editorial`, `isbn_13`, `idioma`, `n_paginas`, `publicacion`, `descripcion`, `encuadernacion`, `imagen`, `disponibles`, `prestados`, `created_at`, `updated_at`) VALUES
('kO_IEAAAQBAJ', 'MARVEL: La enciclopedia', 'Introducción de Stan Lee', 'DK', '9780241413074', 'es', 448, '2019-09-24', 'Mantente al día con el universo en constante expansión de Marvel con la nueva edición de la enciclopedia más vendida de DK, esta vez con una introducción de Stan Lee.\r\n\r\nDescubre los hechos esenciales sobre los heroes de Marvel Comics como el Capitán America, Spider-Man y Iron Man, y villanos como Thanos, Loki y Kingpin. Actualizada y expandida, esta enciclopedia definitiva de Marvel Comics revela información vital e historias secretas de más de 1200 personajes clásicos y nuevos de Marvel, y proporciona información sobre eventos clave recientes como Civil War 2, Secret Empire e Infinity Countdown.\r\n\r\nCon una introducción de Stan Lee, investigada meticulosamente e increíblemente ilustrada, esta magnífica guía del Universo Marvel presenta más de 1200 personajes atemporales de Marvel Comics. Los personajes aparecen representados con ilustraciones de los mejores artistas de Marvel Comics y acompañados de detallados perfiles redactados por un equipo de expertos en los cómics de Marvel.', 'Tapa dura', 'https://imagessl4.casadellibro.com/a/l/s7/74/9780241413074.webp', 5, 0, '2025-04-02', '2025-04-02'),
('KylVT18NAh4C', 'Delirio ', '(Premio Alfaguara de novela 2004)', 'ALFAGUARA', '9788420401751', 'es', 352, '2004-03-31', '«Todos los secretos están guardados en un mismo cajón, el cajón de los secretos, y si desvelas uno, corres el riesgo de que pase lo mismo con los demás.»\r\n\r\nUn hombre regresa a casa después de un corto viaje de negocios y encuentra que su esposa ha enloquecido completamente. No tiene idea de qué le ha podido ocurrir durante los tres días de su ausencia, y con el fin de ayudarla a salir de la crisis empieza a investigar, solo para descubrir lo poco que sabe sobre las profundas perturbaciones escondidas en el pasado de la mujer que ama.\r\n\r\nNarrada con talento y emoción, la historia principal de esta novela se fragmenta en otras que se anudan a través de personajes llenos de matices. Laura Restrepo muestra en esta obra una energía narrativa fuera de lo común, en donde el suspense se mantiene hasta un final esperanzador que cierra una hermosa novela, bien construida, mejor controlada y brillantemente desarrollada.', 'Tapa blanda', 'https://imagessl1.casadellibro.com/a/l/s7/51/9788420401751.webp', 10, 0, '2025-04-02', '2025-04-29'),
('lX9gzwEACAAJ', 'El arte de la guerra', '', 'Austral', '9788408262442', 'es', 160, '2022-09-07', '«El agua para fluir se adapta al terreno, el guerrero para vencer se adapta al enemigo.»\r\n\r\nDesde la disposición de los ejércitos hasta el uso de espías, pasando por el estudio del terreno o la relación entre los mandos y los soldados rasos. Puede parecer que los trece capítulos de El arte de la guerra el maestro Sun solo nos habla de estrategia militar, pero lo sugerente de sus sentencias y la profundidad de sus enseñanzas sobre el control de los tiempos, la psicología de las personas y los grupos o la naturaleza del poder convierten este clásico del pensamiento oriental en lectura obligatoria para todo el que quiera aprender a lidiar con éxito con sus conflictos cotidianos.\r\n\r\n«El estratega victorioso vence primero y después lucha. El estratega fracasado primero lucha y después busca la victoria.»\r\n\r\nAdemás, esta edición incluye explicaciones que ayudan a comprender el significado de las observaciones de Sun Tzu y hacen el texto mucho más accesible para los lectores de hoy.', 'De bolsillo', 'https://imagessl2.casadellibro.com/a/l/s7/42/9788408262442.webp', 10, 0, '2025-04-02', '2025-06-03'),
('MjA0EAAAQBAJ', 'Mapa dibujado por un espía', '', 'Galaxia Gutenberg', '9788415472766', 'es', 400, '2013-11-06', 'Las memorias más políticas de Guillermo Cabrera Infante, crónica de su desencanto ante la Revolución y su decisión de exiliarse definitivamente\r\n\r\nLibro de memorias casi secreto e inedito a la muerte del autor, Mapa dibujado por un espía narra los apuros que vivió Guillermo Cabrera Infante en el verano de 1965, cuando regresó a Cuba desde Belgica para asistir al entierro de su madre. Fue el momento de abrir los ojos a la vertiente totalitaria de la Revolución, cuyas autoridades le negaron la visa de salida, obligándolo a permanecer cuatro meses en la isla hasta encontrar una nueva vía de escape a Europa. La crónica de ese tiempo muerto refleja un mundo espectral y desmoronado, así como el desconcierto de quien no consigue despertar de las pesadillas de la Historia.', 'Tapa blanda', 'https://imagessl6.casadellibro.com/a/l/s7/66/9788415472766.webp', 10, 0, '2025-04-02', '2025-06-03'),
('mM4eEQAAQBAJ', 'Tengo un plan: lo que ellos saben y tú no', '39 principios para crear una vida con resultados y ser feliz', 'CONECTA', '9788418053474', 'es', 224, '2024-10-10', 'DOS CHICOS, DOS MICRÓFONOS Y MUCHA CURIOSIDAD.\r\n\r\nLo que vas a encontrar en este libro es una caja de herramientas prácticas para mejorar, día a día, tu salud física y mental, tus relaciones y tu economía. Más de doscientas personas han pasado por Tengo un Plan y nos han permitido reunir todas estas claves. Te ofrecemos 39 principios de los mayores expertos en cada área, sintetizados con el objetivo de que los apliques fácilmente en tu rutina. Si consigues hacer tuyo uno de estos principios y que tu vida sea un poco mejor, para nosotros ya habrá merecido la pena.', 'Tapa blanda', 'https://imagessl4.casadellibro.com/a/l/s7/74/9788418053474.webp', 10, 0, '2025-04-02', '2025-04-02'),
('oPinEAAAQBAJ', 'La crianza imperfecta', 'Por qué no puedes llegar a todo, y está bien así', 'BRUGUERA', ' 9788402428349', 'es', 240, '2023-03-02', 'Despues de Madre, llega un nuevo libro para acompañar en la maternidad y la crianza de la mano de Paola Roig.\r\n\r\nEl libro que necesitamos leer para liberarnos de la culpa y sentirnos acompañadas en el proceso de ser madres.\r\n\r\nLas madres millenials vivimos en la era de la información. Sabemos que zapatos son mejores para nuestras criaturas, a que edad es mejor introducir el gluten en su dieta y tambien cómo deberíamos acompañarlos en una rabieta.\r\n\r\nNos pasamos la crianza intentando cambiar patrones, y hacer las cosas distintas, intentando ser madres de libro. ¿Pero quien habla de todo lo que nos pasa a nosotras mientras intentamos alcanzar todo eso?\r\n\r\nCuando me propusieron escribir un segundo libro, decidí que quería que fuese sobre la crianza. No obstante, ya hay tantos libros sobre el tema que es fácil perderse en dar indicaciones y consejos y en vender que todas las soluciones van a poder encontrarse en unas pocas líneas.\r\n\r\nYo no quiero participar de eso. Yo quiero hablar de la crianza desde la psicología, claro, pero tambien desde la vivencia. La de las madres a las que acompaño y la mía propia. Quiero hablar de lo que nos sucede, de todo lo que nos cuesta tanto nombrar, de lo que mueven nuestras criaturas en nosotras y de cómo podemos hacer más sencillo el camino de acompañarlas y de acompañarnos.\r\n\r\nEsto es lo que encontrarás aquí. Voy a ir recorriendo los aspectos más importantes de la crianza, esos que más nos preocupan y sobre los cuales más leemos. Voy a darte un poco de teoría para entenderlos y ponerlos en contexto, y luego te plantearé preguntas para que tú puedas escoger tu propio camino, confiando en tus recursos y todo aquello que ya tienes dentro de ti.\r\n\r\nNo, este no es otro manual sobre como ser una madre perfecta. Es un libro para encontrar y confiar en la madre suficientemente buena que ya eres.', 'Tapa blanda', 'https://imagessl9.casadellibro.com/a/l/s7/49/9788402428349.webp', 10, 0, '2025-04-02', '2025-04-02'),
('p6nWEAAAQBAJ', 'Bajo la superficie', '', 'DEBOLS!LLO', '9788466370653', 'es', 368, '2023-10-26', 'Un reloj en marcha, un siniestro acosador y un nuevo romance se combinan en esta apasionante continuación de la serie Bajo Sospecha\r\n\r\nLa productora de televisión Laurie Moran y su prometido, Alex Buckley, antiguo presentador de su programa de televisión de investigación, están a pocos días de su boda a mediados de verano cuando las cosas toman un oscuro giro. Johnny, el sobrino de siete años de Alex, desaparece en la playa, lo que desencadena un dispositivo de búsqueda.\r\n\r\nLos testigos recuerdan a Johnny jugando en el agua y recogiendo conchas detrás de una cabaña, pero nadie asegura haberlo visto por la tarde. Al ponerse el sol, la tabla de skimboard de Johnny llega a la orilla y todos están de acuerdo en que el niño podría estar en cualquier parte, incluso bajo el agua.', 'De bolsillo', 'https://imagessl3.casadellibro.com/a/l/s7/53/9788466370653.webp', 10, 0, '2025-04-02', '2025-05-29'),
('pcM2EAAAQBAJ', '50 herramientas de coaching nutricional para la salud y el bienestar', '', 'DEBOLS!LLO', '9788466358309', 'es', 296, '2021-07-08', '50 herramientas imprescindibles para tener una alimentación saludable.\r\n\r\nMás de 100.000 personas lo han logrado gracias al coaching nutricional.\r\n\r\nSer consciente de la importancia de tener una alimentación saludable es clave para llevar a cabo un cambio en nuestros hábitos, pero no siempre es suficiente. La falta de tiempo, los antojos, los pensamientos saboteadores, las emociones negativas que nos invaden y que tendemos a compensar con comida insana, así como los eventos sociales que en ocasiones nos empujan a romper nuestro compromiso o un entorno que no siempre nos lo pone fácil son obstáculos que debemos aprender a superar.\r\n\r\nEste libro ofrece herramientas que nos ayudarán a afrontar esta difícil tarea. Nos acompaña en un increíble viaje de autoconocimiento en el que, a través de los ejercicios que propone, aprenderemos a identificar las barreras que nos impiden mantener el tipo de alimentación que deseamos, a la vez que nos invita a abandonar aquellas viejas rutinas que tanto se resisten a la hora de introducir un verdadero cambio en nuestras vidas.', 'De bolsillo', 'https://m.media-amazon.com/images/I/71q8yrW9uTL._SL1500_.jpg', 10, 0, '2025-04-02', '2025-04-02'),
('pNyJEAAAQBAJ', 'The Turn of the Screw and other Ghost Stories', '', 'Penguin Classics', '9780141389752', 'en', 384, '2017-05-26', 'An unsettling new collection of Henry James\'s best short stories exploring ghosts and the uncanny, edited by Susie Boyt. In \'The Turn of the Screw\', one of the most famous ghost stories of all time, a governess becomes obsessed with the belief that malevolent forces are stalking the children in her care. But are the children really in danger - and if so, from who? The novella is accompanied here by several more tales exploring human psychology through ghostly visitations and the uncanny, including \'The Romance of Certain Old Clothes\', \'The Last of the Valerii\', \'Sir Edmund Orme\', \'Owen Wingrave\', \'The Friend of the Friends\', \'The Third Person\' and \'The Jolly Corner\'. This is the final volume of three new Penguin Classics collections representing the best of Henry James\'s short fiction. The other volumes are \'The Aspern Papers and Other Tales\', focussing on themes of art and literature, and \'Daisy Miller and Other Tales\', exploring Anglo-American relations.', 'Tapa blanda', 'https://m.media-amazon.com/images/I/71eZOYeB6bL._AC_UF1000,1000_QL80_.jpg', 10, 0, '2025-04-02', '2025-04-30'),
('poasEAAAQBAJ', 'Historia de la Segunda Guerra Mundial sin mitos ni tópicos', '', 'B DE BOLSILLO', '9788413144351', 'es', 568, '2023-03-23', 'En Historia de la Segunda Guerra Mundial sin mitos ni tópicos, Manuel P. Villatoro e Israel Viana, periodistas especializados en historia, nos acercan al conflicto más grande de todos los tiempos bajo la premisa de una pulgación fresca y amena, en la que se incluyen varias exclusivas jamás contadas, fruto de la investigación de los autores.\r\n\r\nSin olvidar los hechos previos al enfrentamiento, ni sus largas consecuencias en el corto siglo XX, el libro ofrece una crónica de la guerra año por año, atenta a sus entresijos y al enorme sufrimiento humano que supuso. Se encontrarán aquí entrevistas con algunos de los últimos supervivientes y los acontecimientos bélicos más destacados, como la invasión de Polonia por las tropas del Tercer Reich o las asfixiantes batallas marítimas en el interior de los submarinos, pero también aparecerán pinceladas sobre detalles como el funcionamiento del Panzer, las obsesiones eróticas de Hitler y Mussolini, el desempeño de las mujeres espías en el frente o el desesperado encargo hecho por el Kremlin a Dmitri Shostakóvich de estrenar su Sinfonía n.º 7, con una orquesta diezmada, en la ciudad sitiada de Leningrado.', 'De bolsillo', 'https://imagessl1.casadellibro.com/a/l/s7/51/9788413144351.webp', 10, 0, '2025-04-02', '2025-04-02'),
('PUeCAAAACAAJ', 'Bauhaus. Edición actualizada', '', 'Taschen', '9783836565523', 'es', 552, '2020-07-03', 'Catorce años. En ese breve período entre dos guerras mundiales, la escuela de arte y diseño alemana Bauhaus sentó las bases de la modernidad. A partir de una visión utópica del futuro, la escuela desarrolló una práctica vanguardista que fusionaba las bellas artes, la artesanía y la tecnología con el objetivo de aplicarla en otros medios y actividades artísticas.', 'Tapa dura', 'https://imagessl3.casadellibro.com/a/l/s7/23/9783836565523.webp', 10, 0, '2025-04-02', '2025-05-31'),
('p_AYEQAAQBAJ', 'El Incal (Integral)', '', 'Reservoir Books', '9788416709298', 'es', 432, '2017-03-23', 'Esta es la epopeya de John Difool, un detective de poca monta que al recibir un extraño objeto debe enfrentarse, sin habérselo propuesto, a los altos poderes del cosmos.\r\n\r\nMientras, irrumpen varias rebeliones a la vez en el imperio galáctico; siembran el caos, así como la caída y el renacimiento de múltiples poderes y contrapoderes. Difool deberá viajar, junto a la abigarrada compañía metafísica que forman su pájaro Deepo y otros cinco elegidos, por el magistral universo futurista creado por Jodorowsky y Moebius.\r\n\r\nEl Incal es, sin duda, un clásico de la ciencia ficción donde la aventura y la filosofía copulan sobre los más asombrosos parajes lisérgicos.\r\n\r\n«Probablemente la mayor suma de talentos de la historia del cómic.»\r\nRolling Stone', 'Tapa dura', 'https://m.media-amazon.com/images/I/81FaRzlZ65L._SL1500_.jpg', 8, 0, '2025-04-02', '2025-06-03'),
('Q6V_yuqA2hMC', 'El turno del escriba', 'Premio Alfaguara de novela 2005', 'ALFAGUARA', '9788420467498', 'es', 272, '2005-03-29', 'Esta novela, ganadora del Premio Alfaguara de novela de 2005, es la recreación de una época fascinante de la humanidad, la de los descubrimientos y la atracción por lo desconocido, que trasciende el marco histórico para convertir su escritura deslumbrante en un acto de libertad.\r\n\r\nEn 1298, Rustichello de Pisa vive su decimocuarto año como rehén de guerra de los genoveses. Este escribano viejo y cansado alguna vez copió manuscritos para las casas reales más grandes de Europa, pero ningún monarca parece ahora interesado en pagar su rescate.\r\n\r\nSu destino cambia cuando un nuevo prisionero viene a compartir su celda. Es Marco Polo, el viajero veneciano que llegó a los confines del Oriente. Rustichello adivina enseguida el tesoro que tiene entre manos, y así da comienzo a una epopeya secreta y grandiosa: la redacción, a partir de los relatos de Marco Polo, de una obra que le atraerá de nuevo el favor de los príncipes cristianos, el\r\nLibro de las maravillas del mundo.', 'Tapa blanda', 'https://imagessl8.casadellibro.com/a/l/s7/98/9788420467498.webp', 10, 0, '2025-04-02', '2025-05-25'),
('QqccCwAAQBAJ', 'Los pazos de Ulloa. La madre naturaleza', '', 'Alianza Editorial', '9788413620947', 'es', 640, '2020-10-29', 'Cuando el joven sacerdote don Julián se presenta en la hacienda de los Pazos de Ulloa, en la Galicia rural, para ejercer de administrador, contra lo que cabría esperar del nombre del lugar y de las resonancias del marquesado de Ulloa, el mundo con el que se halla está lejos de cualquier grandeza y, en cuanto a los mecanismos y pasiones que en él rigen, próximo a un primitivismo medieval. Las figuras del sobrevenido marqués don Pedro, del malicioso mayordomo Primitivo y de su hija Sabel, consciente de las armas de su sexo, son el punto de partida de un relato en el cual palpitan el atraso y la decadencia, las ambiciones y el aislamiento, el instinto frente a la sociedad, la inanidad de la nobleza frente a la férrea determinación del aldeano y, finalmente, el enfrentamiento entre la atracción y el amor que impone la \"madre naturaleza\" y la inexorable regla que dicta la convención social.', 'Tapa dura', 'https://imagessl7.casadellibro.com/a/l/s7/47/9788413620947.webp', 10, 0, '2025-04-02', '2025-04-02'),
('RHQgAwAAQBAJ', 'El mundo de afuera', 'Premio Alfaguara de Novela 2014', 'ALFAGUARA', '9788420416335', 'es', 312, '2014-05-21', 'Premio Alfaguara de Novela 2014\r\n\r\nIsolda vive encerrada en un castillo extraño y fascinante al mismo tiempo, tan ajeno a la ciudad de Medellín en la que se sitúa como singulares son sus habitantes y la vida que llevan. La atmósfera de irrealidad que se respira resulta opresiva para la adolescente, que encuentra en el bosque que lo rodea la única tregua posible a su soledad.\r\n\r\nPero las amenazas invisibles del mundo de afuera se cuelan silenciosamente entre las ramas de los árboles cercanos al castillo. Con un perfecto manejo de la tensión, Jorge Franco construye en esta novela un cuento de hadas con tintes tenebrosos que acaba convirtiendose en la historia desquiciada de un secuestro.\r\n\r\nDentro y fuera de la fortaleza, el amor, ese monstruo indomable, se muestra como una obsesión que aliena y embrutece, que pretende someter, que despierta deseos de venganza y del que solo parece posible escapar aceptando la muerte como destino.', 'Tapa blanda', 'https://imagessl5.casadellibro.com/a/l/s7/35/9788420416335.webp', 10, 0, '2025-04-02', '2025-04-02'),
('SC47EAAAQBAJ', 'Los Buddenbrook', '', 'DEBOLS!LLO', '9788466356152', 'es', 896, '2021-10-21', 'La novela que le valió a Thomas Mann el Premio Nobel: una fabulosa saga histórica sobre la decadencia de una familia burguesa en el siglo XIX\r\n\r\nPublicada en 1901, Los Buddenbrook narra la decadencia de una familia burguesa alemana a lo largo del siglo XIX. En un gran fresco que va desde 1835, cuando aún se recordaban las guerras napoleónicas, hasta 1877, poco antes de la fundación del Imperio Alemán, Mann no solo captura un descenso social, sino tambien las fuerzas históricas que trastocaron la existencia decimonónica y alumbraron las incertidumbres de los tiempos modernos. Basada en su propia novela familiar, la historia anuncia además temas esenciales de su obra posterior, como la compleja relación entre la vida y el arte, o el contraste entre la esfera pública y la privada.', 'De bolsillo', 'https://imagessl2.casadellibro.com/a/l/s7/52/9788466356152.webp', 10, 0, '2025-04-02', '2025-04-02'),
('SOjIDAAAQBAJ', 'El libro de las brujas: casos de brujería en Inglaterra y en las colonias norteamericana (1582-1813)', '', 'Alba Editorial', '9788490652244', 'es', 384, '2016-08-20', '\r\nEl libro de las brujas repasa uno de los períodos más oscuros de la historia a través de una galería de hechos y personajes escalofriante. Katherine Howe, profesora de la Universidad de Cornell y descendiente de tres brujas acusadas enlos juicios de Salem de 1692, ha recogido en estelibro un gran número de documentos relacionadoscon la brujería y los procesos por brujería desde finales del siglo XVI hasta principios del XIX. El pánico de Salem, que llevó a la horca a veinte personas (catorce de ellas mujeres), no fue una anomalía sino la consecuencia de un largo proceso de tipificación de la figura de la bruja y de su castigo por poner en peligro la fe y la cohesión de la comunidad.', 'Tapa dura', 'https://imagessl4.casadellibro.com/a/l/s7/44/9788490652244.webp', 10, 0, '2025-04-02', '2025-04-02'),
('TDlPEAAAQBAJ', 'El revés y el derecho', 'Premio Nobel de Literatura', 'DEBOLS!LLO', '9788466358132', 'es', 128, '2022-01-27', 'Primer libro de Albert Camus, una colección de ensayos sobre su patria y sus viajes escritos con toda la fuerza de la juventud\r\n\r\nÓpera prima de Albert Camus, que la escribió con solo veintidós años, El reves y el derecho contiene cinco ensayos autobiográficos sobre el barrio de Argel, los orígenes del autor y dos viajes iniciáticos por Baleares y Europa Central.\r\n\r\nCargado de lirismo, el conjunto es un soberbio testimonio acerca de su juventud y el encuentro sensual con el mundo. Pero en estas páginas se oculta tambien, como afirmó el mismo Camus al final de su vida, el íntimo manantial de su obra, \"las dos o tres imágenes sencillas y grandiosas\" que nunca dejó de buscar \"por los desvíos del arte\".', 'De bolsillo', 'https://imagessl2.casadellibro.com/a/l/s7/32/9788466358132.webp', 10, 0, '2025-04-02', '2025-06-03'),
('Tj1zBwAAQBAJ', 'Mi abuela, la loca', '', 'Alfaguara Infantil', '9788416490943', 'es', 144, '2022-02-07', 'Un cuento acerca de la iniciación en el mundo de la lectura y la escritura, a través de la inspiradora huella que una abuela fuera de serie deja en un niño.\r\n\r\n\"Mmm... Yo sólo sé que mi abuela está loca. Ah, y que tiene la culpa de todo. Sí, ¡de todo! Siempre hay alguien culpable de que a uno le guste eso que tanto le gusta, o de que no le guste eso que nunca le ha gustado. El caso es que entre su peinado de Darth Vader, su obsesión de ganarse trofeos por los poemas que escribe y esa manía burlona de recitar versos a todo pulmón cuando bajo del autobús escolar, entre risotadas y con cara de trágame tierra (y todo para obligarme a entrar rápido a su casa), yo me estoy volviendo loco también.\r\n\r\nMis papás tienen un nuevo trabajo, y no tengo otra opción que quedarme por las tardes en casa de Petunia, mi abuela. Pero sospecho que algo se trae entre manos, y no me lo puedo perder...\"', 'Tapa blanda', 'https://imagessl3.casadellibro.com/a/l/s7/43/9788416490943.webp', 10, 0, '2025-04-02', '2025-04-02'),
('uf5NEAAAQBAJ', 'DUNE (Las Crónicas de Dune 1)', '', 'DEBOLS!LLO', '9788466353779', 'es', 784, '2021-03-04', 'La mayor epopeya de todos los tiempos, en nueva edición con la traducción corregida en 2019.\r\n\r\nEn el desertico planeta Arrakis, el agua es el bien más preciado y llorar a los muertos, el símbolo de máxima prodigalidad. Pero algo hace de Arrakis una pieza estrategica para los intereses del Emperador, las Grandes Casas y la Cofradía, los tres grandes poderes de la galaxia. Arrakis es el único origen conocido de la melange, preciosa especia y uno de los bienes más codiciados del universo.\r\n\r\nAl duque Leto Atreides se le asigna el gobierno de este mundo inhóspito, habitado por los indómitos Fremen y monstruosos gusanos de arena de centenares de metros de longitud. Sin embargo, cuando la familia es traicionada, su hijo y heredero, Paul, emprenderá un viaje hacia un destino más grande del que jamás hubiese podido soñar.\r\n\r\nMezcla fascinante de aventura, misticismo, intrigas políticas y ecologismo, Dune se convirtió, desde el momento de su publicación, en un fenómeno de culto y en la mayor epopeya de ciencia-ficción de todos los tiempos.', 'De bolsillo', 'https://imagessl9.casadellibro.com/a/l/s7/79/9788466353779.webp', 10, 0, '2025-04-02', '2025-06-03'),
('u_9JDwAAQBAJ', 'Una novela criminal', 'Premio Alfaguara de novela 2018', 'ALFAGUARA', '9788420432274', 'es', 512, '2018-03-15', 'Todo lo que se narra en esta novela ocurrió así, todos sus personajes son personas de carne y hueso, y la historia, desentrañada con maestría e iluminada hasta sus últimos recovecos por una ingente tarea de documentación, es real.\r\n\r\nEl 8 de diciembre de 2005, al sur de Ciudad de México, la policía federal detiene a Israel Vallarta y a Florence Cassez y los acusa de secuestro e integración en banda criminal. Al día siguiente, a las 06:47 de la mañana, los canales de televisión Televisa y TV Azteca emiten en directo la entrada de los agentes federales en el rancho Las Chinitas, la liberación de tres rehenes y la detención de Israel y Florence. En los días siguientes, los detenidos sufrirán torturas, se les negarán sus derechos y la lista de acusaciones irá en aumento. Pero cuando los abogados defensores captan la inconsistencia entre los partes de detención, los vídeos de la emisión televisiva y la versión de sus defendidos, comienza una carrera contra el tiempo para sacar a la luz uno de los mayores montajes policiales de la historia de México, cuyo desarrollo hizo que se tambalearan los cimientos del gobierno de Felipe Calderón y culminó con un incidente diplomático entre México y Francia.\r\n\r\nNarración despiadada a la hora de mostrar los entresijos del poder, las raíces más hondas de la corrupción y su alcance, así como los embotados mecanismos de la justicia, Una novela criminal es también una valiente denuncia del coste social de las políticas que declaran la guerra al crimen sin poner freno a sus causas.', 'Tapa blanda', 'https://m.media-amazon.com/images/I/914eE1iGnIS._SL1500_.jpg', 10, 0, '2025-04-02', '2025-06-03'),
('VSFzzgEACAAJ', 'Los secretos de las obras de arte', '100 obras maestras en detalle', 'TASCHEN', '9783836577472', 'es', 636, '2020-05-25', 'Esta obra resulta básica para entender las obras maestras de la historia del arte, ya que pone bajo la lupa algunos de los lienzos más famosos del mundo para descubrir sus elementos más pequeños y sutiles, y todo lo que pueden llegar a revelar sobre una cultura, un lugar y una epoca ya pasados. Dirigiendo nuestra mirada a los más mínimos detalles y al simbolismo que hay tras las obras, Rose-Marie y Rainer Hagen permiten que las imágenes más conocidas cobren de nuevo vida a traves de sus complejidades e intrigas. ¿Está embarazada la novia? ¿Por que lleva gorra el hombre? ¿Cómo se cierne la sombra de la guerra sobre una escena de baile? Así, viajamos desde el antiguo Egipto hasta la moderna Europa, desde el Renacimiento hasta los alocados años veinte. Conocemos a heroes griegos y poetas alemanes sumidos en la pobreza. Visitamos catedrales y clubes de cabaret, el jardín del Eden y un banco en un jardín de la Francia rural.', 'Tapa dura', 'https://m.media-amazon.com/images/I/81Cd9hcXJNL._SL1500_.jpg', 5, 0, '2025-04-02', '2025-06-03'),
('wVHKDAAAQBAJ', 'Cuentos imprescindibles', 'Edición de Richard Ford', 'Penguin Clásicos', '9788491051923', 'es', 480, '2016-10-06', '\"Casi siempre la máxima expresión de la felicidad o de la desgracia es el silencio.\"\n\nComo el drama, el relato corto se ajusta al proyecto literario de Chejov: \"No he adquirido una perspectiva política, ni filosófica, ni religiosa sobre la vida... Tengo que limitarme a las descripciones de cómo mis personajes aman, se casan, tienen hijos, hablan y se mueren\". El genio de Chejov estalla en esas pinceladas, retazos de vida crepusculares, pesimistas, a veces irónicos y siempre lºcidos, reflejo de una realidad que comienza a disolverse envuelta en su mediocridad y falta de aliento.\n\nEl Premio Pulitzer 1996 Richard Ford ha desempeñado, paralelamente a su trayectoria como narrador, la monumental tarea de editar la obra de Antón Chejov. El presente volumen toma como referencia su trabajo y ofrece al lector hispanoparlante una antología de los mejores cuentos del escritor ruso, formidablemente vertidos a nuestra lengua.', 'De bolsillo', 'https://imagessl3.casadellibro.com/a/l/s7/23/9788491051923.webp', 10, 0, '2025-04-02', '2025-05-29'),
('XIQZQwAACAAJ', 'La vida es sueño', '', 'Austral', '9788467033953', 'es', 248, '2003-09-04', 'Pocas obras dramáticas se muestran tan vigentes hoy en día como La vida es sueño. Drama religioso o filosófico que, desde el absoluto seiscentista, urde sus raíces en los mitos orientales, la literalidad de su lección moral es capaz, sin embargo . de traducirse en lectura política (educación de príncipes) y en grito revolucionario. Pero, sobre todo, es pieza clave en la historia del conocimiento, del reconocimiento por parte del hombre de su conciencia de existir. Desde el mito de la caverna de Platón hasta la frontera de la modernidad que supone su proximidad en el tiempo y en las inquietudes a la filosofía cartesiana, La vida es sueño se constituye en un modelo de la duda metódica resuelta no a través de la seguridad del pensar, sino por medio de una peripecia trágica que desemboca en el absoluto moral. Por medio de una magnífica parábola literaria y de la grandiosidad de una puesta en escena que vislumbramos en la fuerza suasoria del discurso, Calderón muestra cómo sobre el error no se puede levantar el edificio de la verdad. Y que para la pasión, como todo lo humano, puede someterse a sistema.', 'De bolsillo', 'https://imagessl3.casadellibro.com/a/l/s7/53/9788467033953.webp', 10, 0, '2025-04-02', '2025-06-01'),
('XlKIEAAAQBAJ', 'El primer café de la mañana', '', 'B DE BOLSILLO', '9788413145518', 'es', 304, '2022-10-20', 'Una historia llena de magia que nos recuerda que el amor puede encontrarse a tan solo un cafe de distancia\r\n\r\nEn pleno centro de Roma, en el barrio del Trastevere, se encuentra el Tiberi, un pequeño bar familiar que siempre desprende un delicioso aroma a cafe. Su dueño, Massimo, se ha dedicado en cuerpo y alma a su cafetería. Por eso, a sus apenas treinta años, ha conseguido convertirla en un lugar alegre, bohemio y relajado. Cada día sigue la misma rutina, guiada por los mismos clientes y nuevas recetas. Y sin embargo, se siente vacío.\r\n\r\nHasta que un día una joven francesa, de increíbles ojos verdes, entra en el Tiberi y la vida de Massimo cambia en ese mismo instante, atraído por el misterio que parece envolverla. Pero hablar con ella es casi imposible: no coinciden en idioma, personalidad... ni siquiera en sus gustos: él dedicado al café, ella al té.\r\n\r\nDiego Galdino, llevándonos por las preciosas calles de Roma y París, ha creado en esta novela una historia sencilla a la que es imposible resistirse.', 'De bolsillo', 'https://imagessl8.casadellibro.com/a/l/s7/18/9788413145518.webp', 10, 0, '2025-04-02', '2025-05-29'),
('xQNmEAAAQBAJ', 'Bajo el volcán', '', 'DEBOLS!LLO', '9788466359849', 'es', 512, '2022-04-28', 'Una de las indiscutidas obras maestras del siglo XX, Bajo el volcán relata las últimas horas de la decadencia de un hombre apresado en el alcoholismo.\r\n\r\nGeoffrey Firmin, excónsul británico en México, se ha instalado en Quauhnáhuac, a la vera del famoso volcán, sin otra intención que dar rienda suelta a su alcoholismo.\r\n\r\nEn la jornada más fatídica de su vida, que no por azar coincide con el día de los muertos, su mujer llega a la ciudad para tratar de rescatarlo y salvar su matrimonio. Sin embargo, este própósito choca con la presencia de quienes ayudan sin saberlo a Firmin en su adicción.\r\n\r\nContra un trasfondo a la vez festivo y siniestro, los asuntos del día se van encaminando poco a poco hacia un final inevitable, mientras se perfila un retrato no solo de un hombre volcado en la autodestrucción, sino de toda una generación fascinada con la muerte.', 'De bolsillo', 'https://imagessl9.casadellibro.com/a/l/s7/49/9788466359849.webp', 10, 0, '2025-04-02', '2025-06-03'),
('ybQVwwEACAAJ', 'Ilíada', '', 'Austral', '9788467055214', 'es', 464, '2019-03-12', 'Unos pocos días antes del último de los diez años que duró el asedio de los aqueos a la ciudad de Troya, proporcionan el marco cronológico a los acontecimientos narrados en la Ilíada, el poema más antiguo de la literatura occidental. Producto de una larga tradición oral, la epopeya, como advierte su autor en el primer verso, relata la historia de las consecuencias de una pasión humana. Aquiles, encolerizado por el ultraje de Agamenón, que como caudillo de la expedición griega le ha arrebatado a Briseida, decide retirarse del combate. Pero no tardará mucho en volver a él, con furia renovada, a raíz de la muerte de su compañero Patroclo a manos de los troyanos.', 'De bolsillo', 'https://imagessl4.casadellibro.com/a/l/s7/14/9788467055214.webp', 10, 0, '2025-04-02', '2025-05-09'),
('YjLFswEACAAJ', 'Odisea', '', 'Austral', '9788467050059', 'es', 448, '2017-05-04', 'He aquí uno de los más grandes poemas épicos de todos los tiempos: Odisea. En él se narra el regreso del héroe, Odiseo, a su patria, Ítaca, después de la conquista de Troya. Compuesta como la Ilíada en hexámetros, recoge numerosos cuentos populares y leyendas que, adaptadas, se integran en la epopeya. De este modo, mientras que en la Ilíada el tema central, la cólera de Aquiles, va avanzando inexorablemente, verso a verso, desde su planteamiento hasta su desenlace, en Odisea el regreso del héroe es narrado, con arte magistral, sin recelar de las vueltas atrás o de las digresiones, porque el objetivo supremo es lograr mayor gozo en la narración de bellas historias. Todo ello se logra, además, sin que merme en absoluto la cohesión que mantiene unidos sus episodios.', 'De bolsillo', 'https://imagessl9.casadellibro.com/a/l/s7/59/9788467050059.webp', 10, 0, '2025-04-02', '2025-04-02'),
('yr6CyVLtOmoC', 'Drácula', '', 'Penguin Clásicos', '9788491050230', 'es', 536, '2015-07-02', 'Un clásico de la literatura de terror, los orígenes de una criatura terrible y fascinante.\r\n\r\nTraducción de Mario Montalbán\r\n\r\nPrefacio de Christopher Frayling, mítico estudioso de la cultura popular\r\n\r\nIntroducción de Maurice Hindle, profesor de la Open University\r\n\r\nJonathan Harker viaja a Transilvania para cerrar un negocio inmobiliario con un misterioso conde que acaba de comprar varias propiedades en Londres. Despues de un viaje plagado de ominosas señales, Harker es recogido en el paso de Borgo por un siniestro carruaje que lo llevará, acunado por el canto de los lobos, a un castillo en ruinas. Tal es el inquietante principio de una novela magistral que alumbró uno de los mitos más populares y poderosos de todos los tiempos: Drácula.\r\n\r\nLa presente edición incluye una detallada cronología y el prefacio del reputado catedrático y crítico Christopher Frayling, donde se analiza la figura de Stoker y las circunstancias que propiciaron la creación de Drácula. Asimismo, la perspicaz introducción a cargo del especialista Maurice Hindle reflexiona sobre los aspectos más polemicos en torno al origen del prototipo vampírico. La cuidada traducción es de Mario Montalbán.', 'De bolsillo', 'https://imagessl0.casadellibro.com/a/l/s7/30/9788491050230.webp', 10, 0, '2025-04-02', '2025-04-02'),
('zE0aEAAAQBAJ', 'Lo que escondían sus ojos', '', 'B DE BOLSILLO', '9788413142388', 'es', 672, '2021-04-15', '\"-¿Cómo empezó todo?\r\n\r\n-Fue en el otoño del año 1940, en plena posguerra...\"\r\n\r\nUna autentica historia de amor prohibido que demuestra, una vez más, que la vida puede ser más fascinante que la ficción.\r\n\r\n1940, Madrid. La Guerra Civil ha terminado hace un año y la alta sociedad española reinicia sus fiestas y encuentros, buscando distraerse de la amenaza de la posible entrada de España en la Segunda Guerra Mundial y de las penurias que vive el país. En una de las lujosas fiestas celebradas en el Ritz se conocen dos personas destinadas a vivir una pasión inevitable.\r\n\r\nCuando Sonsoles de Icaza, marquesa de Llanzol, conoce al poderoso Ramón Serrano Súñer, nuevo ministro de Asuntos Exteriores, solo una mirada le basta para enamorarse, a sabiendas de que su relación es imposible. En un país devastado, en un ambiente de falsa neutralidad, espionajes y traiciones, esta pasión clandestina dio pie al acontecimiento más comentado y más silenciado de la epoca: el nacimiento de Carmen Díez de Rivera. El escándalo fue tal que ambas familias ocultaron el asunto como si nunca hubiera existido...\r\n\r\nLo que escondían sus ojos es una gran novela histórica rigurosamente documentada que refleja perfectamente el ambiente de la alta sociedad española de la posguerra y el ambiente político en una Europa asediada por la guerra.', 'De bolsillo', 'https://imagessl8.casadellibro.com/a/l/s7/88/9788413142388.webp', 10, 0, '2025-04-02', '2025-04-02'),
('zIoTEAAAQBAJ', 'El libro para personas ocupadas', '', 'B DE BOLSILLO', '9788413142494', 'es', 464, '2021-02-11', 'Nada es casualidad, todo es causalidad.\r\n\r\nUn libro para aprender a superarte e ilusionarte cada día.\r\n\r\nHay días que nos sentimos capaces de cualquier cosa y la vida es maravillosa. Otros, sin embargo, sentimos que todo nos supera y el mundo se convierte en un lugar hostil.\r\n\r\nNuestro cerebro está diseñado para que sobrevivamos, no para que cumplamos nuestros sueños o nuestros propósitos. Pero es posible vencer esos mensajes que nos llevan a nuestra zona de confort, desarrollar hábitos que nos beneficien y entrenar como un músculo nuestro afán de superación, nuestra constancia y nuestra ilusión.\r\n\r\nEl libro para personas ocupadas recoge metodos y procedimientos para enfrentarnos a los retos del día a día. Puede leerse cómo se quiera: solo hay que abrir una página al azar o curiosear el índice y dejarse llevar por la intuición. Cada capítulo recoge una enseñanza, una pregunta, un descubrimiento para que resuene en nuestro interior y nos ayude en el camino hacia la paz y la plenitud. Porque, aunque a veces lo olvidemos, nacimos para ser felices.', 'De bolsillo', 'https://imagessl4.casadellibro.com/a/l/s7/94/9788413142494.webp', 10, 0, '2025-04-02', '2025-04-02'),
('ZOhWEAAAQBAJ', 'Anna Karénina', '', 'Alianza Editorial', '9788413624037', 'es', 1104, '2021-06-24', 'En 1887, ocho años después de la publicación de Guerra y paz -uno de los más grandes monumentos de la historia de la literatura, ya presente en esta colección-, Lev Tolstói (1828-1910) pone punto final a su novela Anna Karénina, otra de sus grandísimas novelas. Inspirada en algunos hechos reales, la historia tiene como eje el adulterio de la protagonista; sin embargo, éste es sólo parte de una de las tres historias conyugales que se entrelazan en la obra con sus pasiones, sus sufrimientos y sus alegrías, y en todas las cuales late, enorme, esa pulsión de vida que pocos autores como Tolstói han sabido imprimir a los personajes de sus novelas.', 'De bolsillo', 'https://imagessl7.casadellibro.com/a/l/s7/37/9788413624037.webp', 10, 0, '2025-04-02', '2025-06-01'),
('zqw8AwAAQBAJ', 'Fullmetal Alchemist: Fullmetal Edition, Vol. 1', '', 'VIZ LLC', '9780316285483', 'en', 280, '2018-05-08', 'Alchemy: the mystical power to alter the natural world; something between magic, art, and science. When two brothers, Edward and Alphonse Elric, dabbled in this power to grant their dearest wish, one of them lost an arm and a leg...and the other became nothing but a soul locked into a body of living steel. Now Edward is a agent of the government, a slave of the military-alchemical complex, using his unique powers to obey orders...even to kill. Except his powers aren\'t unique. The world has been ravaged by the abuse of alchemy. And in the pursuit of the ultimate alchemical treasure, the Philosopher\'s Stone, their enemies are even more ruthless than they are...', 'Tapa dura', 'https://imagessl9.casadellibro.com/a/l/s7/79/9781421599779.webp', 5, 0, '2025-04-02', '2025-04-02'),
('_H7poAEACAAJ', 'Diseño Del Siglo XX', '', 'Taschen', '9783836541084', 'es', 768, '2012-08-15', 'La biblia del diseño del siglo XX\r\nDel modernismo al minimalismo, pasando por todas las corrientes intermedias\r\nA principios del siglo XXI podemos ver claramente que el anterior estuvo marcado por cambios memorables en el campo del diseño. La estética entró en la vida cotidiana con resultados a menudo asombrosos. Nuestros hogares y lugares de trabajo se convirtieron en verdaderas galerías de estilo e innovación.\r\n\r\nDesde los muebles a las artes gráficas, aquí encontramos todo el trabajo de artistas que dieron forma y recrearon el mundo moderno con una vertiginosa variedad de materiales. De lo orgánico a lo geométrico, desde el art déco hasta el pop y las altas tecnologías, la presente obra contiene todos los grandes nombres: Harry Bertoia, De Stijl, Dieter Rams, Philippe Starck, Charles y Ray Eames, por nombrar solo a algunos. Este libro esencial supone un recorrido a través de las formas y los colores, clases y funciones de la historia del diseño en el siglo XX. Una guía de la A a la Z de diseñadores y escuelas de diseño, que incluye un completo retrato de la vida contemporánea. Profusamente ilustrado, esto es el diseño en su sentido más pleno.', 'Tapa dura', 'https://m.media-amazon.com/images/I/71qpdaBLHBL._SL1500_.jpg', 9, 1, '2025-04-02', '2025-06-03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro_subgenero`
--

CREATE TABLE `libro_subgenero` (
  `id_subgenero` int(11) DEFAULT NULL,
  `id_libro` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro_subgenero`
--

INSERT INTO `libro_subgenero` (`id_subgenero`, `id_libro`) VALUES
(95, 'G-TJtAEACAA'),
(97, 'B_XDEAAAQBAJ'),
(91, '8hfwCwAAQBAJ'),
(91, 'ZOhWEAAAQBAJ'),
(101, 'G-TJtAEACAAJ'),
(101, '1pX-AgAAQBAJ'),
(103, '1pX-AgAAQBAJ'),
(1, '0atkAAAACAAJ'),
(1, 'iQtQPQAACAAJ'),
(95, '3jjIEAAAQBAJ'),
(95, '3jjIEAAAQ54L'),
(95, 'A2HcEAAAQBAJ'),
(91, 'xQNmEAAAQBAJ'),
(95, 'p6nWEAAAQBAJ'),
(101, '3jjIEAAAQBAJ'),
(101, 'A2HcEAAAQBAJ'),
(101, '3jjIEAAAQ54L'),
(1, 'PUeCAAAACAAJ'),
(104, 'jgzZEAAAQBAJ'),
(104, 'FdQ-EQAAQBAJ'),
(104, 'p_AYEQAAQBAJ'),
(104, 'FqEkEQAAQBAJ'),
(150, '0qYJEAAAQBAJ'),
(89, 'gdhJEAAAQBAJ'),
(101, 'gdhJEAAAQBAJ'),
(102, 'HfepCAAAQBAJ'),
(91, 'cqahDAAAQBAJ'),
(91, 'wVHKDAAAQBAJ'),
(97, '8jFVDgAAQBAJ'),
(98, 'KylVT18NAh4C'),
(1, '_H7poAEACAAJ'),
(103, 'yr6CyVLtOmoC'),
(91, 'yr6CyVLtOmoC'),
(143, 'SOjIDAAAQBAJ'),
(149, 'SOjIDAAAQBAJ'),
(9, 'zIoTEAAAQBAJ'),
(10, 'zIoTEAAAQBAJ'),
(10, 'HUMjEAAAQBAJ'),
(92, 'RHQgAwAAQBAJ'),
(102, 'RHQgAwAAQBAJ'),
(97, 'XlKIEAAAQBAJ'),
(92, 'FfsVCgAAQBAJ'),
(101, 'FfsVCgAAQBAJ'),
(101, 'Eas4AwAAQBAJ'),
(103, 'Eas4AwAAQBAJ'),
(92, 'KJZeEAAAQBAJ'),
(91, 'KJZeEAAAQBAJ'),
(16, 'TDlPEAAAQBAJ'),
(87, 'Q6V_yuqA2hMC'),
(87, 'GGaREAAAQBAJ'),
(86, 'GRHAEAAAQBAJ'),
(95, 'GRHAEAAAQBAJ'),
(99, 'GRHAEAAAQBAJ'),
(86, 'bsYtDwAAQBAJ'),
(89, 'bsYtDwAAQBAJ'),
(91, 'bsYtDwAAQBAJ'),
(185, 'bsYtDwAAQBAJ'),
(185, '8hfwCwAAQBAJ'),
(103, 'pNyJEAAAQBAJ'),
(91, 'pNyJEAAAQBAJ'),
(98, 'pNyJEAAAQBAJ'),
(156, 'poasEAAAQBAJ'),
(91, 'ybQVwwEACAAJ'),
(7, 'oPinEAAAQBAJ'),
(91, 'HAuSDwAAQBAJ'),
(89, 'HAuSDwAAQBAJ'),
(104, 'zqw8AwAAQBAJ'),
(104, 'iF0-AwAAQBAJ'),
(104, '2rA8AwAAQBAJ'),
(104, '910-AwAAQBAJ'),
(6, 'A8oVEQAAQBAJ'),
(91, 'XIQZQwAACAAJ'),
(159, 'aKz6EAAAQBAJ'),
(91, '6dwVtgEACAAJ'),
(87, 'zE0aEAAAQBAJ'),
(87, 'SC47EAAAQBAJ'),
(91, 'SC47EAAAQBAJ'),
(95, 'i8mXDwAAQBAJ'),
(101, 'i8mXDwAAQBAJ'),
(95, 'JW1nEAAAQBAJ'),
(101, 'JW1nEAAAQBAJ'),
(91, 'QqccCwAAQBAJ'),
(1, 'VSFzzgEACAAJ'),
(16, 'MjA0EAAAQBAJ'),
(87, '--SiQBe51WQC'),
(10, 'mM4eEQAAQBAJ'),
(9, 'mM4eEQAAQBAJ'),
(104, 'kO_IEAAAQBAJ'),
(97, 'hmN4m0y6byAC'),
(91, 'YjLFswEACAAJ'),
(91, 'Frh-CgAAQBAJ'),
(97, 'Frh-CgAAQBAJ'),
(91, '49aCDwAAQBAJ'),
(89, 'uf5NEAAAQBAJ'),
(97, '9XBdtQW57NQC'),
(91, 'ilPkDwAAQBAJ'),
(91, '94D_CgAAQBAJ'),
(14, 'u_9JDwAAQBAJ'),
(6, 'pcM2EAAAQBAJ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_de_espera`
--

CREATE TABLE `lista_de_espera` (
  `id` int(11) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_libro` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lista_de_espera`
--

INSERT INTO `lista_de_espera` (`id`, `fecha`, `id_usuario`, `id_libro`, `created_at`, `updated_at`) VALUES
(1, '2025-06-03 16:52:14', 1, 'G-TJtAEACAAJ', '2025-06-03 16:52:14', '2025-06-03 16:52:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2025_03_30_205619_create_sessions_table', 1),
(2, '0001_01_01_000001_create_cache_table 22-55-56-175', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `fecha` date NOT NULL,
  `portada` varchar(255) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_libro` varchar(50) NOT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp(),
  `updated_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamos`
--

CREATE TABLE `prestamos` (
  `id` int(11) NOT NULL,
  `fecha_pedido` date NOT NULL,
  `cod_pedido` varchar(25) DEFAULT NULL,
  `recibido` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_recibido` datetime DEFAULT NULL,
  `fecha_devolucion` date DEFAULT NULL,
  `fecha_devuelto` datetime DEFAULT NULL,
  `foto_envio` varchar(255) DEFAULT NULL,
  `extension` text DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_libro` varchar(50) NOT NULL,
  `direccion` varchar(150) NOT NULL,
  `piso` varchar(20) DEFAULT NULL,
  `puerta` varchar(10) DEFAULT NULL,
  `provincia` varchar(45) NOT NULL,
  `localidad` varchar(100) NOT NULL,
  `cod_postal` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telf` varchar(25) DEFAULT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `dni` varchar(12) NOT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp(),
  `updated_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamos`
--

INSERT INTO `prestamos` (`id`, `fecha_pedido`, `cod_pedido`, `recibido`, `fecha_recibido`, `fecha_devolucion`, `fecha_devuelto`, `foto_envio`, `extension`, `id_usuario`, `id_libro`, `direccion`, `piso`, `puerta`, `provincia`, `localidad`, `cod_postal`, `email`, `telf`, `nombre`, `apellidos`, `dni`, `created_at`, `updated_at`) VALUES
(1, '2025-06-02', '6835edbd', 1, '2025-06-03 18:57:06', '2025-06-23', '2025-06-03 17:00:31', 'X8Krre9B5mkYsG3FPcs2SIPSODvLts05JO7QJVyj.jpg', NULL, 1, 'uf5NEAAAQBAJ', 'Calle San Jerónimo, 15', '1', 'A', 'Granada', 'Granada', '18001', 'b.ruiz@gmail.com', '608303030', 'Blanca', 'Ruiz', '02485847F', '2025-06-03', '2025-06-03'),
(2, '2025-06-02', '683de5a7', 1, '2025-06-03 18:57:36', '2025-06-23', NULL, NULL, NULL, 1, '_H7poAEACAAJ', 'Calle San Jerónimo, 15', '1', 'A', 'Granada', 'Granada', '18001', 'b.ruiz@gmail.com', '608303030', 'Blanca', 'Ruiz', '02485847F', '2025-06-03', '2025-06-03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subgeneros`
--

CREATE TABLE `subgeneros` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `id_genero` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subgeneros`
--

INSERT INTO `subgeneros` (`id`, `nombre`, `id_genero`) VALUES
(1, 'Bellas Artes e Historia del Arte', 1),
(6, 'Nutrición y salud', 2),
(7, 'Piscología y pedagogía', 2),
(9, 'Desarrollo personal', 2),
(10, 'Inspiración y motivación', 2),
(14, 'Crimen real', 3),
(16, 'Memorias', 3),
(86, 'Acción y aventuras', 7),
(87, 'Novela histórica', 7),
(89, 'Ciencia ficción', 7),
(91, 'Clásicos', 7),
(92, 'Fantasía', 7),
(95, 'Misterio', 7),
(97, 'Novela romántica', 7),
(98, 'Psicológica', 7),
(99, 'Comedia', 7),
(101, 'Sagas', 7),
(102, 'Thriller y suspense', 7),
(103, 'Terror', 7),
(104, 'Cómics y novela gráfica', 1),
(143, 'América', 9),
(149, 'Estados Unidos', 9),
(150, 'Europa', 9),
(156, 'Mundial', 9),
(159, 'Filología', 9),
(185, 'Clásicos', 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `dni` varchar(15) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `telf` varchar(25) DEFAULT NULL,
  `pfp` varchar(255) DEFAULT NULL,
  `id_domicilio` int(11) DEFAULT NULL,
  `updated_at` date NOT NULL DEFAULT current_timestamp(),
  `created_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `nombre`, `apellidos`, `email`, `password`, `dni`, `fecha_nac`, `telf`, `pfp`, `id_domicilio`, `updated_at`, `created_at`) VALUES
(1, 'Blanca', 'Ruiz', 'b.ruiz@gmail.com', '$2y$12$/6Vz.wMKenwWwT1RLAQHzOqfvXmIOrE6EWi4vdneAkMYeN7szcz9e', '02485847F', '1999-02-02', '608303030', 'jYQxAbiT5NaKYePzVLYgblnSozkgSMzmvHrDdMES.jpg', 1, '2025-06-03', '2025-06-03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wishlist`
--

CREATE TABLE `wishlist` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_libro` varchar(50) DEFAULT NULL,
  `fecha` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `wishlist`
--

INSERT INTO `wishlist` (`id`, `id_usuario`, `id_libro`, `fecha`, `created_at`, `updated_at`) VALUES
(1, 1, '_H7poAEACAAJ', '2025-06-03 16:52:32', '2025-06-03 14:52:32', '2025-06-03 14:52:32'),
(2, 1, 'G-TJtAEACAAJ', '2025-06-03 16:52:37', '2025-06-03 14:52:37', '2025-06-03 14:52:37');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `autores`
--
ALTER TABLE `autores`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `autor_libro`
--
ALTER TABLE `autor_libro`
  ADD KEY `id_autor` (`id_autor`),
  ADD KEY `id_libro` (`id_libro`);

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `domicilios`
--
ALTER TABLE `domicilios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_usuario_2` (`id_usuario`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `generos`
--
ALTER TABLE `generos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `genero_libro`
--
ALTER TABLE `genero_libro`
  ADD KEY `id_genero` (`id_genero`),
  ADD KEY `id_libro` (`id_libro`);

--
-- Indices de la tabla `libros`
--
ALTER TABLE `libros`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `lista_de_espera`
--
ALTER TABLE `lista_de_espera`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_libro` (`id_libro`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `fk_libros_notificaciones` (`id_libro`);

--
-- Indices de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cod_pedido` (`cod_pedido`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_libro` (`id_libro`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `subgeneros`
--
ALTER TABLE `subgeneros`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_generos_subgeneros` (`id_genero`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_usuarios_domicilios` (`id_domicilio`);

--
-- Indices de la tabla `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_libro` (`id_libro`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `autores`
--
ALTER TABLE `autores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT de la tabla `domicilios`
--
ALTER TABLE `domicilios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `generos`
--
ALTER TABLE `generos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `lista_de_espera`
--
ALTER TABLE `lista_de_espera`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `subgeneros`
--
ALTER TABLE `subgeneros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=244;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `autor_libro`
--
ALTER TABLE `autor_libro`
  ADD CONSTRAINT `autor_libro_ibfk_1` FOREIGN KEY (`id_autor`) REFERENCES `autores` (`id`),
  ADD CONSTRAINT `autor_libro_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id`);

--
-- Filtros para la tabla `domicilios`
--
ALTER TABLE `domicilios`
  ADD CONSTRAINT `domicilios_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `genero_libro`
--
ALTER TABLE `genero_libro`
  ADD CONSTRAINT `genero_libro_ibfk_1` FOREIGN KEY (`id_genero`) REFERENCES `generos` (`id`),
  ADD CONSTRAINT `genero_libro_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id`);

--
-- Filtros para la tabla `lista_de_espera`
--
ALTER TABLE `lista_de_espera`
  ADD CONSTRAINT `lista_de_espera_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `lista_de_espera_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id`);

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `fk_libros_notificaciones` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id`),
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD CONSTRAINT `prestamos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `prestamos_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id`);

--
-- Filtros para la tabla `subgeneros`
--
ALTER TABLE `subgeneros`
  ADD CONSTRAINT `fk_generos_subgeneros` FOREIGN KEY (`id_genero`) REFERENCES `generos` (`id`);

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_usuarios_domicilios` FOREIGN KEY (`id_domicilio`) REFERENCES `domicilios` (`id`);

--
-- Filtros para la tabla `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
