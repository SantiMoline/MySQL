-- A continuación, se deben realizar las siguientes consultas sobre la base de datos:
-- 1. Mostrar el nombre de todos los jugadores ordenados alfabéticamente.
SELECT Nombre FROM jugadores 
ORDER BY Nombre;

-- 2. Mostrar el nombre de los jugadores que sean pivots (‘C’) y que pesen más de 200 libras, ordenados por nombre alfabéticamente.
SELECT Nombre from jugadores
WHERE Posicion = "C";

-- 3. Mostrar el nombre de todos los equipos ordenados alfabéticamente.
SELECT Nombre FROM equipos
ORDER BY Nombre;

-- 4. Mostrar el nombre de los equipos del este (East).
SELECT Nombre FROM equipos
WHERE Conferencia = "East";

-- 5. Mostrar los equipos donde su ciudad empieza con la letra ‘c’, ordenados por nombre.
SELECT Nombre FROM equipos
WHERE Ciudad LIKE "c%"
ORDER BY Nombre;

-- 6. Mostrar todos los jugadores y su equipo ordenados por nombre del equipo.
SELECT Nombre, Nombre_equipo FROM jugadores
ORDER BY Nombre_equipo;

-- 7. Mostrar todos los jugadores del equipo “Raptors” ordenados por nombre.
SELECT Nombre FROM jugadores
WHERE Nombre_equipo = "Raptors"
ORDER BY Nombre;

-- 8. Mostrar los puntos por partido del jugador ‘Pau Gasol’.
SELECT e.Puntos_por_partido FROM estadisticas e
INNER JOIN jugadores j ON j.codigo = e.jugador
WHERE j.Nombre = "Pau Gasol";

-- 9. Mostrar los puntos por partido del jugador ‘Pau Gasol’ en la temporada ’04/05′.
SELECT e.temporada, e.Puntos_por_partido FROM estadisticas e
INNER JOIN jugadores j ON j.codigo = e.jugador
	WHERE j.nombre = "Pau Gasol" 
		AND e.temporada = "04/05";
        
-- 10. Mostrar el número de puntos de cada jugador en toda su carrera.
SELECT j.nombre, SUM(e.Puntos_por_partido) AS Ptos_totales FROM estadisticas e
INNER JOIN jugadores j ON j.codigo = e.jugador
	GROUP BY j.nombre ORDER BY Ptos_totales DESC;

-- 11. Mostrar el número de jugadores de cada equipo.
SELECT Nombre_equipo, COUNT(*) AS Cantidad_jugadores FROM jugadores
GROUP BY Nombre_equipo;

-- 12. Mostrar el jugador que más puntos ha realizado en toda su carrera.
SELECT j.nombre FROM jugadores j 
INNER JOIN estadisticas e ON j.codigo = e.jugador
	GROUP BY j.nombre 
    ORDER BY SUM(e.Puntos_por_partido) DESC
		LIMIT 1;

-- 13. Mostrar el nombre del equipo, conferencia y división del jugador más alto de la NBA.
SELECT j.Nombre_equipo, e.Conferencia, e.Division FROM jugadores j 
INNER JOIN equipos e ON j.Nombre_equipo = e.Nombre
	ORDER BY j.Altura DESC
	LIMIT 1;

-- 14. Mostrar el partido o partidos (equipo_local, equipo_visitante y diferencia) con mayor diferencia de puntos.
SELECT equipo_local, equipo_visitante, ABS(puntos_local - puntos_visitante) AS diferencia_puntos FROM partidos
ORDER BY diferencia_puntos DESC
LIMIT 1;
SELECT * FROM partidos;
-- 15. Mostrar quien gana en cada partido (codigo, equipo_local, equipo_visitante, equipo_ganador), en caso de empate sera null.
SELECT codigo, equipo_local, equipo_visitante, 
	IF(puntos_local > puntos_visitante, equipo_local, IF(puntos_visitante > puntos_local, equipo_visitante, null)) AS equipo_ganador 
		FROM partidos

