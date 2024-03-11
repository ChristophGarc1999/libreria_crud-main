<?php
// Check existence of id parameter and table name before processing further
if(isset($_GET["id"]) && !empty(trim($_GET["id"])) && isset($_GET["table"]) && !empty(trim($_GET["table"]))){

    // Include config file
    require_once "config.php";
    
    // Validate input and sanitize it to prevent SQL injection
    $id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
    $table = filter_input(INPUT_GET, 'table', FILTER_SANITIZE_STRING);

    // Determine the correct ID field based on the table name
    switch ($table) {
        case 'Autores':
            $id_field = "ID_Autor";
            break;
        case 'Editoriales':
            $id_field = "ID_Editorial";
            break;
        case 'Generos':
            $id_field = "ID_Genero";
            break;
        case 'Libros':
            $id_field = "ID_Libro";
            break;
        case 'Ventas':
            $id_field = "ID_Venta";
            break;
        case 'DetalleVenta':
            $id_field = "ID_DetalleVenta";
            break;
        case 'Compras':
            $id_field = "ID_Compra";
            break;
        case 'DetalleCompra':
            $id_field = "ID_DetalleCompra";
            break;
        case 'EmpleadosBasicos':
            $id_field = "ID_Empleado";
            break;
        case 'Clientes':
            $id_field = "ID_Cliente";
            break;
        case 'Proveedores':
            $id_field = "ID_Proveedor";
            break;
        case 'EmpleadosDetalles':
            $id_field = "Matricula";
            break;
        default:
            // Redirect to error page if table name is invalid
            header("location: error.php");
            exit();
    }

    // Prepare a select statement based on the table name and ID field
    $sql = "SELECT * FROM $table WHERE $id_field = ?";
    
    // Check if the SQL statement was successfully prepared
    if ($stmt = mysqli_prepare($link, $sql)) {
        // Bind variables to the prepared statement as parameters
        mysqli_stmt_bind_param($stmt, "i", $id);
        
        // Attempt to execute the prepared statement
        if (mysqli_stmt_execute($stmt)) {
            // Get the result set
            $result = mysqli_stmt_get_result($stmt);
    
            // Check if a record was found
            if (mysqli_num_rows($result) == 1) {
                // Fetch result row as an associative array
                $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
            } else {
                // Redirect to error page if no records found
                header("location: error.php");
                exit();
            }
        } else {
            // Error handling for execution of prepared statement
            echo "Oops! Something went wrong. Please try again later.";
        }
        
        // Close the statement
        mysqli_stmt_close($stmt);
    } else {
        // Error handling for preparation of SQL statement
        echo "Oops! Something went wrong. Please try again later.";
    }
    
    // Close connection
    mysqli_close($link);
} else {
    // Redirect to error page if id or table name parameter is missing
    header("location: error.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ver Registro</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css">
    <style type="text/css">
        .wrapper{
            width: 500px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12">
                    <div class="page-header">
                        <h1>Ver Registro</h1>
                    </div>
                    <?php if(isset($row) && !empty($row)): ?>
                    <div class="form-group">
                        <?php foreach($row as $key => $value): ?>
                        <label><?php echo ucfirst($key); ?></label>
                        <p class="form-control-static"><?php echo $value; ?></p>
                        <?php endforeach; ?>
                    </div>
                    <?php else: ?>
                    <p class="alert alert-danger">No se encontraron registros.</p>
                    <?php endif; ?>
                    <p><a href="index.php" class="btn btn-primary">Volver</a></p>
                </div>
            </div>        
        </div>
    </div>
</body>
</html>
