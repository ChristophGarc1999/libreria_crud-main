<?php
session_start();

$jsonInsert='"user": "Christopher", "date":"'.date('Y-m-d H:i:s').'", "secction": "index.php" ';
require "transactions.php";

if (isset($_REQUEST["cmbdb"])) {
    $db = $_REQUEST["cmbdb"];
    $_SESSION["db"] = $db;
} else {
    if (!isset($_SESSION["db"])) {
        header("Location: menu.php"); // Redirige si $_SESSION["db"] no está definido
        exit;
    }
    $db = $_SESSION["db"];
}

echo "Base de datos: " . $_SESSION["db"];
?>
<a href="menu.php" class="btn btn-success pull-right">Cambiar Base de datos</a>
<div>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Dashboard</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.js"></script>
        <style type="text/css">
            .wrapper {
                width: 650px;
                margin: 0 auto;
            }

            .page-header h2 {
                margin-top: 0;
            }

            table tr td:last-child a {
                margin-right: 15px;
            }
        </style>
        <script type="text/javascript">
            $(document).ready(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>
    </head>

    <body>
        <div class="wrapper">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-12">
                        <?php
                        require_once "config.php";

                        $tables = array();
                        if ($db == "MidnightSlayerGDL" || $db == "MidnightSlayerMTY" || $db == "MidnightSlayerCDMX") {
                            $tables = array("Autores", "Editoriales", "Generos", "Libros", "Ventas", "DetalleVenta", "Compras", "DetalleCompra", "EmpleadosBasicos");
                        } elseif ($db == "MidnightSlayerCORP") {
                            $tables = array("Clientes", "Proveedores", "EmpleadosBasicos", "EmpleadosDetalles", "VistaSumatoriaCompras", "VistaSumatoriaVentas", "VistaEmpleadosCompleta");
                        }

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

                        $views = ["VistaSumatoriaCompras", "VistaSumatoriaVentas", "VistaEmpleadosCompleta"];

                        $view_friendly_names = array(
                            "VistaSumatoriaCompras" => "Reporte Compras Sucursales",
                            "VistaSumatoriaVentas" => "Reporte Ventas Sucursales",
                            "VistaEmpleadosCompleta" => "Reporte Empleados"
                        );

                        foreach ($tables as $table) {
                            $friendly_name = isset($view_friendly_names[$table]) ? $view_friendly_names[$table] : ucfirst($table) . ' Detalles';
                            echo '<div class="page-header clearfix">
              <h2 class="pull-left">' . $friendly_name . '</h2>';
                            if (!in_array($table, $views)) {
                                echo '<a href="create.php?table=' . $table . '" class="btn btn-success pull-right">Agregar Nuevo</a>';
                            }
                            echo '</div>';

                            $sql = "SELECT * FROM $table";
                            $result = mysqli_query($link, $sql);
                            if ($result) {
                                if (mysqli_num_rows($result) > 0) {
                                    echo "<table class='table table-bordered table-striped'>";
                                    echo "<thead>";
                                    echo "<tr>";

                                    $fields = mysqli_fetch_fields($result);
                                    foreach ($fields as $field) {
                                        echo "<th>" . $field->name . "</th>";
                                    }

                                    if (!in_array($table, $views)) {
                                        echo "<th>Acción</th>";
                                    }
                                    echo "</tr>";
                                    echo "</thead>";
                                    echo "<tbody>";

                                    while ($row = mysqli_fetch_array($result)) {
                                        echo "<tr>";
                                        foreach ($fields as $field) {
                                            echo "<td>" . htmlspecialchars($row[$field->name]) . "</td>";
                                        }
                                        if (!in_array($table, $views)) {
                                            $id_field = $table_to_id_field[$table];
                                            echo "<td>";
                                            echo "<a href='read.php?id=" . $row[$id_field] . "&table=" . $table . "' title='Ver' data-toggle='tooltip'><span class='glyphicon glyphicon-eye-open'></span></a>";
                                            echo "<a href='update.php?id=" . $row[$id_field] . "&table=" . $table . "' title='Actualizar' data-toggle='tooltip'><span class='glyphicon glyphicon-pencil'></span></a>";
                                            echo "<a href='delete.php?id=" . $row[$id_field] . "&table=" . $table . "&database=" . $db . "' title='Borrar' data-toggle='tooltip'><span class='glyphicon glyphicon-trash'></span></a>";
                                            echo "</td>";
                                        }
                                        echo "</tr>";
                                    }

                                    echo "</tbody>";
                                    echo "</table>";
                                    mysqli_free_result($result);
                                } else {
                                    echo "<p class='lead'><em>No se encontraron registros.</em></p>";
                                }
                            } else {
                                echo "ERROR: No se pudo ejecutar $sql. " . mysqli_error($link);
                            }
                        }
                        mysqli_close($link);
                        ?>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>