<?PHP
	function sendMessage(){
		$content = array(
			"en" => 'Someone is ringing your door bell now!'
		);

		$heading = array(
			"en" => 'Archer, Door Bell is Ringing'
		);

		$subtitle = array(
			"en" => 'Attention !'
		);

		$fields = array(
			'app_id' => "de97fefb-682f-4f5a-acdf-83b8efe4d1f9",
			'included_segments' => array('All'),
      		'data' => array("foo" => "bar"),
			'contents' => $content,
			'headings' => $heading,
			'mutable_content' => false
		);

		$fields = json_encode($fields);
    	print("\nJSON sent:\n");
    	print($fields);

		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json; charset=utf-8',
												   'Authorization: Basic ODU4MzIzN2ItNjgzMS00OWE3LTlhZDctNmM5YWYxMjYzMjQ4'));
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
		curl_setopt($ch, CURLOPT_HEADER, FALSE);
		curl_setopt($ch, CURLOPT_POST, TRUE);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);

		$response = curl_exec($ch);
		curl_close($ch);

		return $response;
	}

	$response = sendMessage();
	$return["allresponses"] = $response;
	$return = json_encode( $return);

  print("\n\nJSON received:\n");
	print($return);
  print("\n");
?>
