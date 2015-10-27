<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="com.example.piano.Note" %>
<%@ page import="com.example.piano.Notepad" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<html>
  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
  </head>

  <body>

    <div id="keyboard_border">
	     <ul id="keyboard">
		      <li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
		      <li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
          <li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
		      <li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
          <li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
		      <li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
          <li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
		      <li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div><span class="black_key"></span></li>
      		<li><div class="white_key"></div></li>
	    </ul>
    </div>

    <br>
    <br>

    <%
        String notepadName = request.getParameter("notepadName");
        if (notepadName == null)
            notepadName = "default";

        pageContext.setAttribute("notepadName", notepadName);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user != null)
        {
            pageContext.setAttribute("user", user);
    %>

            <div class="notepad"><p>Welcome, ${fn:escapeXml(user.nickname)}. (You can
            <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">log out</a>.)</p></div>
    <%
        }
        else
        {
    %>
            <div class="notepad"><p>Welcome.
            <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Log in</a>
            to include your name with notes you post.</p></div>
    <%
        }
    %>

    <%
          Key<Notepad> theNotepad = Key.create(Notepad.class, notepadName);

          List<Note> notes = ObjectifyService.ofy()
              .load()
              .type(Note.class) // We want only Greetings
              .ancestor(theNotepad)    // Anyone in this notepad
              .order("-date")       // Most recent first - date is indexed.
              .limit(5)             // Only show 5 of them.
              .list();

        if (notes.isEmpty()) {
    %>
    <p class="notepad">Notepad '${fn:escapeXml(notepadName)}' has no messages.</p>
    <%
        } else {
    %>
    <p class="notepad">Notes in Notepad '${fn:escapeXml(notepadName)}'.</p>
    <%
            for (Note note : notes) {
                pageContext.setAttribute("note_content", note.content);
                String author;
                if (note.author_email == null) {
                    author = "An anonymous person";
                } else {
                    author = note.author_email;
                    String author_id = note.author_id;
                    if (user != null && user.getUserId().equals(author_id)) {
                        author += " (You)";
                    }
                }
                pageContext.setAttribute("note_user", author);
    %>
    <div class="prev_Notes"><p><b>${fn:escapeXml(note_user)}</b> wrote:</p>
    <blockquote>${fn:escapeXml(note_content)}</blockquote></div>
    <%
            }
        }
    %>

    <form action="/write" method="post">
        <div class="notepad"><textarea name="content" rows="15" cols="40"></textarea></div>
        <div class="notepad"><input type="submit" value="Post Note"/></div>
        <input type="hidden" name="notepadName" value="${fn:escapeXml(notepadName)}"/>
    </form>
    <form action="/piano.jsp" method="get">
      <div class="notepad"><input type="text" name="notepadName" value="${fn:escapeXml(notepadName)}"/></div>
      <div class="notepad"><input type="submit" value="Switch Notepad"/></div>
    </form>
  </body>
</html>
