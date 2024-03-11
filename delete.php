<?php
// Process delete operation after confirmation
if(isset($_GET["id"]) && isset($_GET["table"])) {
    // Include config file
    require_once "config.php";

    // Check if database and table are specified
    if(isset($_GET["database"])) {
        $database = $_GET["database"];
        
        // Prepare a delete statement
        $sql = "DELETE FROM $database.$table WHERE id = ?";
        
        if($stmt = mysqli_prepare($link, $sql)) {
            // Bind variables to the prepared statement as parameters
            mysqli_stmt_bind_param($stmt, "i", $param_id);
            
            // Set parameters
            $param_id = trim($_GET["id"]);
            
            // Attempt to execute the prepared statement
            if(mysqli_stmt_execute($stmt)) {
                // Records deleted successfully. Redirect to landing page
                header("location: index.php");
                exit();
            } else {
                echo "Oops! Something went wrong. Please try again later.";
            }
        }
         
        // Close statement
        mysqli_stmt_close($stmt);
    } else {
        echo "Error: Parámetros no válidos.";
        exit();
    }
    
    // Close connection
    mysqli_close($link);
} else {
    // URL doesn't contain required parameters. Redirect to error page
    header("location: error.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Borrar</title>
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
                        <h1>Borrar Registro</h1>
                    </div>
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="get">
                        <div class="alert alert-danger fade in">
                            <input type="hidden" name="id" value="<?php echo isset($_GET['id']) ? trim($_GET['id']) : ''; ?>"/>
                            <input type="hidden" name="database" value="<?php echo isset($_GET['database']) ? trim($_GET['database']) : ''; ?>"/>
                            <input type="hidden" name="table" value="<?php echo isset($_GET['table']) ? trim($_GET['table']) : ''; ?>"/>
                            <p>¿Está seguro que deseas borrar el registro?</p><br>
                            <p>
                                <input type="submit" value="Si" class="btn btn-danger">
                                <a href="index.php" class="btn btn-default">No</a>
                            </p>
                        </div>
                    </form>
                </div>
            </div>        
        </div>
    </div>
</body>
</html>
