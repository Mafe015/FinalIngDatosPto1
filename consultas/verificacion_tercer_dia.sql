SELECT id_envio, ciudad, transportadora, estado, duracion_minutos, fecha
FROM entregas_db.entregas
WHERE fecha = '2026-10-03'
ORDER BY id_envio;

SELECT COUNT(*) AS total_registros FROM entregas_db.entregas;