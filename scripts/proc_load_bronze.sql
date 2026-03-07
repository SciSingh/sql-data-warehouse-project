/*
======================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
======================================================================================
Script Purpose: 
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
      - Truncates the bronze tables before loading data
      - Uses the `BULK INSERT` command to load data from CSV files to bronze tables.

Parameters
  None.
  This stored procedure does not accept any parameters or return an values

Usage Example:
  EXEC bronze.load_bronze;
==================================================================================
*/
CREATE
	OR
ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
	DECLARE @start_time DATETIME,
		@end_time DATETIME,
		@batch_start_time DATETIME,
		@batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '=============================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=============================================';
		PRINT '---------------------------------------------';
		PRINT 'Loading CRM Table';
		PRINT '---------------------------------------------';

		SET @start_time = GETDATE();

		PRINT '>>Truncating Table: bronze.crm_cust_info';

		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>>Inserting Data Into: bronze.crm_cust_info';

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\saisi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = GETDATE();

		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------------'

		SET @start_time = getdate();

		PRINT '>>Truncating Table: bronze.crm_prd_info';

		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>>Inserting Data Into: bronze.crm_cust_info';

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\saisi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = getdate();

		PRINT '>>Load Duration:' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------------'

		SET @start_time = getdate();

		PRINT '>>Truncating Table: bronze.crm_sales_info';

		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>>Inserting Data Into: bronze.crm_sales_info';

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\saisi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = getdate();

		PRINT '>>Load Duration:' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------------'
		PRINT '---------------------------------------------';
		PRINT 'Loading ERP Table';
		PRINT '---------------------------------------------';

		SET @start_time = getdate();

		PRINT '>>Truncating Table: bronze.erp_cust_az12';

		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>>Inserting Data Into: bronze.erp_cust_az12';

		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\saisi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = getdate();

		PRINT '>>Load Duration:' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------------'

		SET @start_time = getdate();

		PRINT '>>Truncating Table: bronze.erp_loc_a101';

		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>>Inserting Data Into: bronze.erp_loc_a101';

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\saisi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = getdate();

		PRINT '>>Load Duration:' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------------'

		SET @start_time = getdate();

		PRINT '>>Truncating Table: bronze.erp_px_cat_g1v2';

		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>>Inserting Data Into: bronze.erp_px_cat_g1v2';

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\saisi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = getdate();

		PRINT '>>Load Duration:' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------------'

		SET @batch_end_time = GETDATE();

		PRINT '=============================================';
		PRINT 'Loading Bronze Layer is completed';
		PRINT '>>Total Load Duration:' + cast(datediff(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT '=============================================';
	END TRY

	BEGIN CATCH
		PRINT '=============================================';
		PRINT 'Error Occured during loading Bronze Layer'
		PRINT 'Error Message' + Error_Message();
		PRINT 'Error Message' + cast(error_number() AS NVARCHAR);
		PRINT 'Error Message' + cast(error_state() AS NVARCHAR);
		PRINT '=============================================';
	END CATCH
END
