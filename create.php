<?php
// Include config file
session_start();
require_once "config.php";

// Obtener el nombre de la tabla seleccionada por el usuario
$table = $_GET['table'] ?? '';

// Obtener la estructura de la tabla seleccionada
$sql = "SHOW COLUMNS FROM $table";
$result = mysqli_query($link, $sql);
$fields = [];
$id_field = '';
if ($result && mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        if ($row['Extra'] !== 'auto_increment') {
            $fields[] = $row['Field'];
        } else {
            $id_field = $row['Field'];
        }
    }
}

// Definir variables y inicializar con valores vacíos
$field_values = array_fill_keys($fields, '');
$errors = array_fill_keys($fields, '');

// Procesar datos del formulario cuando se envía el formulario
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validar y capturar valores de los campos del formulario
    foreach ($fields as $field) {
        $input_value = trim($_POST[$field]);
        if (empty($input_value)) {
            $errors[$field] = "Por favor ingrese el valor para $field.";
        } else {
            $field_values[$field] = $input_value;
        }
    }

    // Verificar si hay errores de validación antes de insertar en la base de datos
    $errors = array_filter($errors);
    if (empty($errors)) {
        // Preparar una declaración de inserción
        $sql = "INSERT INTO $table (";
        $sql .= implode(", ", array_keys($field_values));
        $sql .= ") VALUES (";
        $sql .= "'" . implode("', '", $field_values) . "'";
        $sql .= ")";
        
        // Ejecutar la declaración preparada
        if (mysqli_query($link, $sql)) {
            // Redirigir a la página de inicio
            header("location: index.php");
            exit();
        } else {
            echo "Algo salió mal. Por favor, inténtelo de nuevo más tarde.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Agregar <?php echo ucfirst($table); ?></title>
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
                        <h2>Agregar <?php echo ucfirst($table); ?></h2>
                    </div>
                    <p>Favor de llenar el siguiente formulario para agregar un registro a la tabla <?php echo ucfirst($table); ?>.</p>
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]) . "?table=$table"; ?>" method="post">
                        <?php foreach ($fields as $field): ?>
                            <div class="form-group <?php echo (!empty($errors[$field])) ? 'has-error' : ''; ?>">
                                <label><?php echo ucfirst($field); ?></label>
                                <input type="text" name="<?php echo $field; ?>" class="form-control" value="<?php echo $field_values[$field]; ?>">
                                <span class="help-block"><?php echo $errors[$field]; ?></span>
                            </div>
                        <?php endforeach; ?>
                        <input type="submit" class="btn btn-primary" value="Guardar">
                        <a href="index.php" class="btn btn-default">Cancelar</a>
                    </form>
                </div>
            </div>        
        </div>
    </div>
</body>
</html>
