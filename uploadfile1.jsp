<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.io.*"%>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	int Max_size=102400*102400;
	String rootPath;//文件保存的目录
	DataInputStream in = null;
	FileOutputStream fileOut = null;
	String remoteAddr = request.getRemoteAddr();//取得客户端的IP地址
	String serverName = request.getServerName();//localhost
	String realPath = request.getRealPath("/");
	
	realPath = realPath.substring(0,realPath.lastIndexOf("\\"));//D:\eclipse-workspace\.metadata\.plugins\org.eclipse.wst.server.core\
																//tmp1\wtpwebapps\webtest 
	rootPath = realPath+"\\upload\\";			//文件的保存目录路径
	out.println("上传文件保存目录为"+rootPath);
	
	String contentType = request.getContentType();//取得客户端上传的数据类型
	try{
		if(contentType.indexOf("multipart/form-data") >=0){
			in = new DataInputStream(request.getInputStream()); //读入上传的数据
			int formDataLength = request.getContentLength();	//所读数据的总字节数
			if(formDataLength > Max_size){
				out.println("<p>上传的文件字节数不可以超过"+Max_size+"</p>");
				return;  //???
			}
			byte dataBytes[] = new byte[formDataLength];  //保存上传文件的数据
			int byteRead = 0;	//读一次的字节数
			int totalBytesRead = 0;  //读多次后的字节数
			while(totalBytesRead < formDataLength){
				byteRead = in.read(dataBytes,totalBytesRead,formDataLength);//三个变量分别为：保存数据的数组，开始读的位置，读取字节数
				totalBytesRead += byteRead;
			}
			String file = new String(dataBytes);//根据byte数组创建字符串
			String saveFile = file.substring(file.indexOf("filename=\"")+10); //从出现  filename=" 的位置加10之后的字符串
			saveFile = saveFile.substring(0,saveFile.indexOf("\n"));	   //C:\Users\JH\Desktop\鎹曡幏.PNG"							
			saveFile = saveFile.substring(saveFile.lastIndexOf("\\")+1,saveFile.indexOf("\""));
			
			//out.print("++"+contentType+"++");		//++multipart/form-data; boundary=---------------------------7e335e1d30210++ 
			int lastIndex = contentType.lastIndexOf("=");
			String boundary = contentType.substring(lastIndex + 1,contentType.length());//---------------------------7e335e1d30210
			String fileName = rootPath + saveFile;
			
			int pos;
			pos = file.indexOf("filename=\"");
			pos = file.indexOf("\n",pos)+1;
			pos = file.indexOf("\n",pos)+1;
			pos = file.indexOf("\n",pos)+1;
			
			int boundaryLocation = file.indexOf(boundary,pos)-4;
			int startPos = ((file.substring(0,pos)).getBytes()).length; //取得文件数据的开始位置
			int endPos = ((file.substring(0,boundaryLocation)).getBytes()).length;//取得文件数据的结束位置
			
			File checkFile =new File(fileName);//检查上传文件是否存在
			if(checkFile.exists()){
				out.println("<p>"+saveFile+"文件已经存在</p>");
			}
			File fileDir = new File(rootPath);//检查上传文件的目录是否存在
			if(!fileDir.exists()){
				fileDir.mkdirs();
			}
			fileOut = new FileOutputStream(fileName);//创建文件的写出类
			fileOut.write(dataBytes,startPos,(endPos - startPos));
			fileOut.close();
			out.println("<p><font color=red size=5>"+saveFile+"文件已成功上传</font></p>");
		}else{
			out.println("<p>上传的数据类型不是multipart/form-data</p>");
		}
	}catch(Exception ex){
		throw new ServletException(ex.getMessage());
	}
	
%>
</body>
</html>