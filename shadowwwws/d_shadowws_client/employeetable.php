<?php
$db=mysqli_connect("localhost", "root", "", "myshadowws_erp");
if(!$db)
{
    echo "Database connection error".mysqli_error();
}
$list =array();
$result=$db->query("SELECT * FROM employee");
if($result){
    while($row = $result->fetch_assoc())
    {
        $list[] =$row;
    }
    echo json_encode($list);
}

?>