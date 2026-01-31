<?php
error_reporting(-1);
ini_set("display_errors", 1);

// Provide your working key
$working_key = '75FC4C28834C28B8ED86C8F84D18D2B4';

// Encrypted data
$encrypted_data = 'c3d62ada2dd4b3dc8ffd874d084403ddb786b5f2cb6167ebf15f451c018d4a337fd9fe44beb52ed8be456649f6dc1fb93e17e6bf8c467a72a407d98741086b70140a3140afc814d01bee9fb2854eb5de28584ba299eca83aa8261cd99ff0332c3d13e70f2ee7e49ca9ceafc22721db9ea2ed5289190adc89fe47802bde52b94f26854af82bb8f972dc06016ec38a96c5dd153f673ce22565a4ed8d205cb7e5485635584cc0f2c1d84a7a33bc16f76a346eba0bfb7ee0c2fe7a8c3039693c1683f2dfc8556fc5cbbd090d4d4b1c404498ff3b09910dc6c9eaa3c7ddd9c7d57ee37c9688d04b5c0295c0ec2f174a65ebeb1b8af2933e20807a175fac6b849cee51133590379dba3173ded483318b4dea7c9088f96703267c115ab52b48a67eb623155f5c9c6d6cd5312f35b4a84acb7df8e5a9355239ea451e13906b883edb2a6855f42feb30cc2d34cc3e0722e2aeb7a26bacc3b9e5bd70706bbeb1b35a3e8d01d76dc0a9f427110e0fe689fff37f9b0ee633246014d51f29031b0d6df5245f05731ff9822e8f04507b968a30ed68c6bede4f59ed71f13964d8ceaa15fe5ccbc7ffce38ecc280d64c78570311b11a733a9ff2e44589a9a54813c9333c1a5f6f6b3f38160ed47efd3fbab3ae18fccdab2e5ab6dc7a4f8d4749825a191e92ccddde3516baaa94dc21b2931dd813a656d9a3e0fc8d2b53ef3d7cf0ae9b6df699e2d2';

// Decrypt the data
$decrypted_data = decrypt($encrypted_data, $working_key);
echo "Decrypted data: " . $decrypted_data;

function decrypt($encryptedText, $key) {
    $key = hextobin(md5($key));
    $initVector = pack("C*", 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f);
    $encryptedText = hextobin($encryptedText);
    $decryptedText = openssl_decrypt($encryptedText, 'AES-128-CBC', $key, OPENSSL_RAW_DATA, $initVector);
    return $decryptedText;
}

function hextobin($hexString) {
    return pack("H*", $hexString);
}
?>