<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql" prefix="sql" %>

<%
	java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat();

	String id = request.getParameter("id");
	if (id == null) id = "";
	id = id.replaceAll("\\W", "");
	if (id.length() < 1) response.sendRedirect("index.jsp");
%>

<sql:query var="histRS" dataSource="jdbc/CascadeDS">
	select tstamp, actionName, who, comments from cxml_workflowhistory where workflowid = '<%= id %>'
</sql:query>

<html>
	<head>
		<title>Workflow Detail</title>
		<link rel="stylesheet" type="text/css" href="perms.css" />
	</head>
	<body>
		<h1>Workflow Detail</h1>
		<c:choose>
			<c:when test="${histRS.rowCount < 1}">
				<p>
					There don't seem to be any history entries for this workflow.
					Are you sure you have selected a valid workflow ID?
				</p>
			</c:when>
			<c:otherwise>
				<table>
					<caption>Workflow History Entries</caption>
					<thead>
						<th>Start date</th>
						
						<th>Action Name</th>
						<th>Who triggered action</th>
						<th>User Comments</th>
					</thead>
					<tbody>
						<c:forEach var="row" items="${histRS.rows}">
							<%
								java.util.Date d = new java.util.Date(((java.util.TreeMap<Object,Long>)pageContext.getAttribute("row")).get("tstamp"));
								String niceDate = fmt.format(d);
							%>
							<tr>
								<td><%= niceDate %></td>								
								<td><c:out value="${row.actionName}" /></td>
								<td><c:out value="${row.who}" /></td>
								<td><c:out value="${row.comments}" /></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<p>
					<a href="index.jsp">Back to workflow list</a>
			</c:otherwise>
		</c:choose>
	</body>
</html>