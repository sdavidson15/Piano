package com.example.piano;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;
import com.googlecode.objectify.Key;

import java.lang.String;
import java.util.Date;
import java.util.List;

@Entity public class Note
{
  @Parent Key<Notepad> theNotepad;
  @Id public Long id;

  public String author_email;
  public String author_id;
  public String content;
  @Index public Date date;

  public Note()
  {
    date = new Date();
  }

  public Note(String pad, String content)
  {
    this();
    if(pad != null)
    {
      theNotepad = Key.create(Notepad.class, pad);  // Creating the Ancestor key
    }
    else
    {
      theNotepad = Key.create(Notepad.class, "default");
    }
    this.content = content;
  }

  public Note(String pad, String content, String id, String email)
  {
    this(pad, content);
    author_email = email;
    author_id = id;
  }
}
