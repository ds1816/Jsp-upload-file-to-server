<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body bgcolor="#ffffff" text="#000000">
	<p><b><font size=5>please select the file to upload:</font></b></p>
	<form method="post" action="uploadfile1.jsp" enctype="multipart/form-data">
		<input type="file" name="file1" size="30"><br>
		 <input type="submit" name="submit" value="upload" >
	</form>
</body>
</html>