with
  Ada.Characters.Handling,
  Ada.Text_IO,
  Ada.Strings.Unbounded,
  Ada.Strings.Unbounded.Text_IO;

procedure Remove_Unwanted_Headers is
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
   Line  : Unbounded_String;
   Part  : Parts := Head;
   Field : Unbounded_String;
begin
   while not End_Of_File loop
      Line := Get_Line;

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
                                             Field = "To:" then
                  Put_Line (Line);
               else
                  Put_Line (Standard_Error, Line);
               end if;
            end if;
         when Content =>
            Put_Line (Line);
      end case;
   end loop;
end Remove_Unwanted_Headers;
