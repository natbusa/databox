
cat /docker-entrypoint-initdb.d/1.create_schema.sql.query \
| clickhouse-client --port 9999 -mn 

cat /tmp/data/tax_bills_june15_bbls_10000.csv | \
/usr/bin/clickhouse-client --port 9999 --input_format_allow_errors_num=10 \
  --query="INSERT INTO tax_bills.tax_bills_nyc FORMAT CSV"
