<?php
include_once("dbconnect.php");

try {
    $sqlselect = "SELECT * FROM `tbl_books`";
    $result = $conn->query($sqlselect);

    if ($result) {
        $books = array();

        while ($row = $result->fetch_assoc()) {
            $book = array(
                'user_id' => $row['user_id'],
                'book_id' => $row['book_id'],
                'book_isbn' => $row['book_isbn'],
                'book_title' => stripslashes($row['book_title']),
                'book_desc' => stripslashes($row['book_desc']),
                'book_author' => stripslashes($row['book_author']),
                'book_price' => $row['book_price'],
                'book_qty' => $row['book_qty'],
                'book_status' => $row['book_status'],
            );

            $books[] = $book;
        }

        $response = array('status' => 'success', 'data' => $books);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Query execution error');
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => 'An error occurred: ' . $e->getMessage());
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

$conn->close();
?>
