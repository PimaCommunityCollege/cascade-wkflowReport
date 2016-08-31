<%@ page import="java.util.Date" %>

<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql" prefix="sql" %>

<%
	java.text.SimpleDateFormat format = new java.text.SimpleDateFormat();
%>

<sql:query var="wRS" dataSource="jdbc/CascadeDS">
select w.id, w.owner, w.startDate, w.name, w.expirationWarningSent, f.cachePath, f.assetType, step.displayName, step.startedOn, step.finishBy, step.owner, step.ownerType  from cxml_workflow w, cxml_foldercontent f, cxml_workflowstep step where w.isCompleted = 0 and w.relatedEntityId = f.id and step.id = w.currentStepId order by w.startDate
</sql:query>

<html>
	<head>
		<title>Workflows</title>
		<link rel="stylesheet" type="text/css" href="report.css" />
	</head>
	<body>	
		<h1>Workflow Report</h1>		
		<c:choose>
			<c:when test="${wRS.rowCount < 1}">
				<p>There are no active workflows at this time.</p>
			</c:when>
			<c:otherwise>
				<table>
						<caption>Workflows</caption>
						<thead>
							<th>Workflow Start date</th>
							<th>Workflow name</th>
							<th>Asset</th>
							<th>Asset type</th>
							<th>Started by</th>
							<th>Current step</th>							
							<th>Current user/group</th>
							<th>Current step started</th>				
						</thead>
					<c:forEach var="w" items="${wRS.rowsByIndex}">						
						<%
							Object[] r = (Object[])pageContext.getAttribute("w");
							Long ts = (Long)r[2];
							Date d = new Date(ts);
							String niceStartDate = format.format(d);

							ts = (Long)r[8];
							d = new Date(ts);
							String niceStepStart = format.format(d);

							/*
							String niceStepDue = "";
							String overdueClass = "";
							java.lang.Long timestamp = ((java.util.TreeMap<Object,Long>)pageContext.getAttribute("w")).get("finishBy");
							if (timestamp != null && timestamp > 0)
							{
								d = new Date(((java.util.TreeMap<Object,Long>)pageContext.getAttribute("w")).get("finishBy"));
								niceStepDue = format.format(d);							
								overdueClass = (true) ? "warning" : "";
							}
							*/
						%>
						<tbody>							
							<tr>
								<td><%= niceStartDate %></td>
								<td>
									<a target="_blank" href="/entity/open.act?type=workflow&amp;id=<c:out value='${w[0]}' />"><c:out value="${w[3]}" /></a>
									<c:if test="${w[4] != 0}" >
										<br />
										<span class="warning">(Expiration warning)</span>
									</c:if>
								</td>
								<td><c:out value="${w[5]}" /></td>
								<td><c:out value="${w[6]}" /></td>
								<td><a target="_blank" href="/entity/open.act?type=user&amp;id=<c:out value='${w[1]}' />"><c:out value="${w[1]}" /></a></td>
								<td><c:out value="${w[7]}" /></td>
								<td>
									<c:choose>
										<c:when test="${w[11] == 1}">
											<a target="_blank" href="/entity/open.act?type=group&amp;id=<c:out value='${w[10]}' />"><c:out value="${w[10]}" /></a>
										</c:when>
										<c:otherwise>
											<a target="_blank" href="/entity/open.act?type=user&amp;id=<c:out value='${w[10]}' />"><c:out value="${w[10]}" /></a>
										</c:otherwise>
									</c:choose>			
								</td>
								<td><%= niceStepStart %></td>
							</tr>						
						</tbody>						
						
					</c:forEach>
				</table>
			</c:otherwise>
		</c:choose>
		

	</body>
</html>

