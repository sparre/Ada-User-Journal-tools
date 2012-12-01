with
  Ada.Characters.Handling,
  Ada.Characters.Latin_1,
  Ada.Text_IO,
  Ada.Strings.Unbounded,
  Ada.Strings.Unbounded.Text_IO;

procedure Remove_Unwanted_Headers is
   function Is_Whitespace (Item : in Character) return Boolean is
      use Ada.Characters.Handling, Ada.Characters.Latin_1;
   begin
      return Is_Control (Item) or Item = ' ' or Item = NBSP;
   end Is_Whitespace;

   function "=" (Left  : Ada.Strings.Unbounded.Unbounded_String;
                 Right : String) return Boolean is
      use Ada.Characters.Handling, Ada.Strings.Unbounded;
   begin
      return To_Lower (To_String (Left)) = To_Lower (Right);
   end "=";

   use
     Ada.Characters.Handling,
     Ada.Text_IO,
     Ada.Strings.Unbounded,
     Ada.Strings.Unbounded.Text_IO;

   type Parts is (Head, Content);
   Line       : Unbounded_String;
   Next_Line  : Unbounded_String;
   Part       : Parts := Head;
   Field      : Unbounded_String;
begin
   Next_Line := Get_Line;

   while not End_Of_File loop
      Line := Next_Line;

      loop
         Next_Line := Get_Line;
         exit when Part = Content;
         exit when Length (Next_Line) = 0;
         exit when not Is_Whitespace (Element (Next_Line, 1));
         Append (Line, Next_Line);
      end loop;

      case Part is
         when Head =>
            if Length (Line) = 0 then
               New_Line;
               Part := Content;
            else
               Field :=
                 To_Unbounded_String (Slice (Line, 1, Index (Line, ":")));

               if Field = "Subject:" or else Field = "From:" or else
                                             Field = "Date:" or else
                                             Field = "Newsgroups:" or else
                                             Field = "URL:" or else
                                             Field = "To:" or else
                                             Field = "Cc:" or else
                                             Field = "Bcc:" then
                  Put_Line (Line);
               else
                  Put_Line (Standard_Error, Line);
               end if;
            end if;
         when Content =>
            if Length (Line) >= 5 and then Slice (Line, 1, 5) = "From " then
               Part := Head;
            else
               Put_Line (Line);
            end if;
      end case;
   end loop;

   Put_Line (Next_Line);
end Remove_Unwanted_Headers;
