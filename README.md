# Final Ingeniería de Datos: Entregas con Athena y Partition Projection

## Prerrequisitos
- Cuenta de AWS con credenciales configuradas (aws configure)
- AWS CLI v2, Terraform >= 1.5, Git, PowerShell
- Región: us-east-1
- Bucket usado: entregas-mafe015-2026 (cambiar si ya existe)

## 1. Despliegue
cd infraestructura
terraform init
terraform apply -auto-approve -var="bucket_name=entregas-mafe015-2026"
terraform output -json > ../evidencias/outputs.json
Evidencias: evidencias/aplicacion_terraform.txt y evidencias/outputs.json.

## 2. Etapa inicial (días 1 y 2)
Se suben solo estos dos archivos, uno por uno:aws s3 cp data/entregas/fecha=2026-10-01/entregas.csv s3://BUCKET/entregas/fecha=2026-10-01/entregas.csv
aws s3 cp data/entregas/fecha=2026-10-02/entregas.csv s3://BUCKET/entregas/fecha=2026-10-02/entregas.csv
Se ejecutan las consultas de consultas/ en el workgroup entregas_wg y los resultados se guardan en resultados/inicial/. Cada ejecución queda en evidencias/ejecuciones_athena.csv con etapa inicial.

## 3. Día 3
Solo se sube el archivo y se consulta, sin crawlers, MSCK REPAIR ni ALTER TABLE:
aws s3 cp data/entregas/fecha=2026-10-03/entregas.csv s3://BUCKET/entregas/fecha=2026-10-03/entregas.csv
Se ejecutan consultas/verificacion_tercer_dia.sql y se repiten las consultas de intentos y porcentaje. Resultados en resultados/final/ y ejecuciones con etapa final.

## 4. Limpieza
cd infraestructura
terraform destroy -auto-approve -var="bucket_name=entregas-mafe015-2026"
Evidencia: evidencias/eliminacion_terraform.txt.

## 5. Respuestas conceptuales
Ver respuestas.md.