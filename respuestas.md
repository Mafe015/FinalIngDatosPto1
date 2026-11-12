# Respuestas conceptuales

## 1. ¿Por qué se pudo consultar el tercer día sin registrar una partición nueva?

La tabla no guarda una lista de particiones en el catálogo. Con partition projection, Athena calcula las fechas en el momento de la consulta usando las reglas de las propiedades de la tabla (tipo date, formato yyyy-MM-dd, rango 2026-10-01 a 2026-10-03 e intervalo de 1 día) y arma la ruta de cada fecha con storage.location.template. El 3 de octubre ya estaba dentro del rango desde el despliegue inicial; solo faltaba el archivo en S3. Al subir entregas.csv a entregas/fecha=2026-10-03/, Athena lo encontró en la ruta calculada, sin crawlers, sin MSCK REPAIR TABLE y sin ALTER TABLE ADD PARTITION. La evidencia es que la tabla pasó de 12 a 18 registros (resultados/final/verificacion_total_tabla.csv) sin modificar la infraestructura.

## 2. Si se subiera un archivo para el 4 de octubre con la configuración actual, ¿qué se esperaría y qué habría que modificar?

Con el rango actual, el 4 de octubre queda fuera de la proyección, así que Athena no lo considera y las consultas no devolverían sus filas (resultado vacío, sin error), aunque el archivo exista en S3. Para incluirlo habría que cambiar projection.fecha.range en Terraform a "2026-10-01,2026-10-04" y volver a aplicar. La proyección tampoco crea archivos ni garantiza datos: una fecha dentro del rango sin objeto en S3 también devuelve cero filas.