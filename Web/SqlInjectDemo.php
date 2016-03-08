<?php
$mysqli = new mysqli("localhost", "root", "meiyoumima", "mySqlInject");

/* check connection */
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}
if(isset($_GET['id'])){

	/* Select queries return a resultset */
	if ($mysqli->multi_query("SELECT * FROM malware_result WHERE id='".$_GET['id']."' LIMIT 10")) {
		
		echo "<br>id Params:<pre style='color:red'>10' and 1=2 union select * from information_schema.schemata WHERE 0='</pre>";
		echo "<br>Exec SQL:<br><pre style='color:red'>";
		echo "SELECT * FROM malware_result WHERE id='".$_GET['id']."' LIMIT 10";
		echo "</pre>";
		echo "<br>Example:<br><pre style='color:red'>SELECT task_id,malware_result FROM malware_result WHERE id='10' and 1=2 union select TABLE_SCHEMA,TABLE_NAME from information_schema.tables WHERE TABLE_SCHEMA='mywebretine' LIMIT 10 </pre>";
		
		if($result = $mysqli->use_result()){
			while ($row = $result->fetch_row()) {
                var_dump($row);
            }
			
		}
		
		echo "Select returned ".$result->num_rows." rows.\n";
		/* free result set */
		$result->close();
	}
}
$mysqli->close();
