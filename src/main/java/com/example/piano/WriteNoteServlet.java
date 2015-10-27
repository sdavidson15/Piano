package com.example.piano;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

public class WriteNoteServlet extends HttpServlet
{
  @Override public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException
  {
    Note note;

    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();  // Find out who the user is.

    String notepadName = req.getParameter("notepadName");
    String content = req.getParameter("content");
    if (user != null)
    {
      note = new Note(notepadName, content, user.getUserId(), user.getEmail());
    }
    else
    {
      note = new Note(notepadName, content);
    }

    ObjectifyService.ofy().save().entity(note).now();

    resp.sendRedirect("/piano.jsp?notepadName=" + notepadName);
  }
}
