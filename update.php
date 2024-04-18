<?php
session_start();
// Include config file
require_once "config.php";

// Transacciones
$jsonInsert='"user": "Christopher", "date":"'.date('Y-m-d H:i:s').'", "secction": "update.php" ';
require "transactions.php";
// Define variables and initialize with empty values
$field_values = array();
$errors = array();
$update_required = false;

// Processing form data when form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST["id"];

    // Get field values from POST data
    foreach ($_POST as $key => $value) {
        if ($key != "id") {
            $field_values[$key] = trim($value);
        }
    }

    // Validate and update data
    $table = $_SESSION["table"] ?? '';
    $id_field = $_SESSION["id_field"] ?? '';

    if (!empty($table) && !empty($id_field)) {
        $sql = "UPDATE $table SET ";
        $update_values = array();

        foreach ($field_values as $key => $value) {
            // Only validate and update non-empty fields
            if (!empty($value)) {
                $update_values[] = "$key = '" . mysqli_real_escape_string($link, $value) . "'";
                $update_required = true;
            }
        }

        // Construct the SQL query only if there are fields to update
        if ($update_required) {
            $sql .= implode(", ", $update_values) . " WHERE $id_field = $id";

            if (mysqli_query($link, $sql)) {
                header("location: index.php");
                exit();
            } else {
                echo "Error: " . mysqli_error($link);
            }
        } else {
            // No fields were updated
            header("location: index.php");
            exit();
        }
    } else {
        echo "Error: Parámetros no válidos.";
        exit();
    }
}

// Fetch field names and current values for the selected record
if (isset($_GET["id"]) && isset($_GET["table"])) {
    $id = $_GET["id"];
    $table = $_GET["table"];

    // Definir un array asociativo que mapee el nombre de la tabla al nombre del campo de ID correspondiente
    $table_to_id_field = array(
        "Autores" => "ID_Autor",
        "Editoriales" => "ID_Editorial",
        "Generos" => "ID_Genero",
        "Libros" => "ID_Libro",
        "Ventas" => "ID_Venta",
        "DetalleVenta" => "ID_DetalleVenta",
        "Compras" => "ID_Compra",
        "DetalleCompra" => "ID_DetalleCompra",
        "EmpleadosBasicos" => "ID_Empleado",
        "Clientes" => "ID_Cliente",
        "Proveedores" => "ID_Proveedor",
        "EmpleadosDetalles" => "Matricula"
    );

    if (array_key_exists($table, $table_to_id_field)) {
        $id_field = $table_to_id_field[$table];
    } else {
        echo "Error: No se encontró el campo de identificación para la tabla especificada.";
        exit();
    }

    $result = mysqli_query($link, "SELECT * FROM $table WHERE $id_field = $id");

    if ($result && mysqli_num_rows($result) == 1) {
        $row = mysqli_fetch_assoc($result);
        $field_values = $row;
    } else {
        echo "Error: No se encontró el registro.";
        exit();
    }

    mysqli_free_result($result);
} else {
    echo "Error: Parámetros no válidos.";
    exit();
}

mysqli_close($link);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Registro</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css">
    <style type="text/css">
        .wrapper{
            width: 500px;
            margin: 0 auto;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12">
                    <div class="page-header">
                        <h2>Actualizar Registro</h2>
                    </div>
                    <p>Edite los valores de entrada y envíe para actualizar el registro.</p>
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                        <?php foreach ($field_values as $key => $value): ?>
                            <?php if ($key == $id_field): ?>
                                <input type="hidden" name="id" value="<?php echo $value; ?>">
                            <?php else: ?>
                                <div class="form-group">
                                    <label><?php echo ucfirst(str_replace('_', ' ', $key)); ?></label>
                                    <input type="text" name="<?php echo $key; ?>" class="form-control" value="<?php echo $value; ?>">
                                    <span class="error"><?php echo isset($errors[$key]) ? $errors[$key] : ''; ?></span>
                                </div>
                            <?php endif; ?>
                        <?php endforeach; ?>
                        <input type="submit" class="btn btn-primary" value="Enviar">
                        <a href="index.php" class="btn btn-default">Cancelar</a>
                    </form>
                </div>
            </div>        
        </div>
    </div>
</body>
</html>
