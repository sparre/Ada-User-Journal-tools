with
  Ada.Characters.Handling,
  Ada.Characters.Latin_1,
  Ada.Text_IO,
  Ada.Strings.Unbounded,
  Ada.Strings.Unbounded.Text_IO;

procedure Reorder_Headers is
   type Headlines is (From, Date, Subject, Source);

   function "=" (Left, Right : String) return Boolean;
   --  Case-insensitive comparison.

   function Value (Item : String) return Headlines;
   --  Classifies header entries.

   function Is_Headline (Item : Ada.Strings.Unbounded.Unbounded_String)
                        return Boolean;

   function "=" (Left, Right : String) return Boolean is
      use Ada.Characters.Handling;
   begin
      return Standard."=" (To_Lower (Left), To_Lower (Right));
   end "=";

   function Is_Headline (Item : Ada.Strings.Unbounded.Unbounded_String)
                        return Boolean is
      use Ada.Strings.Unbounded;
      Separator : constant Natural := Index (Item, ": ");
   begin
      if Separator > 0 then
         declare
            Dummy : Headlines;
            pragma Unreferenced (Dummy);
         begin
            Dummy := Value (Slice (Item, 1, Separator));
            return True;
         exception
            when Constraint_Error =>
               return False;
         end;
      else
         return False;
      end if;
   end Is_Headline;

   function Value (Item : String) return Headlines is
   begin
      if Item = "From:" then
         return From;
      elsif Item = "Date:" then
         return Date;
      elsif Item = "Subject:" or else Item = "IRC-channel:" then
         return Subject;
      elsif Item = "Newsgroups:" or else Item = "URL:" or else
                                         Item = "To:" or else
                                         Item = "Cc:" or else
                                         Item = "Bcc:" or else
                                         Item = "IRC-network:"
      then
         return Source;
      else
         Ada.Text_IO.Put_Line
           (File => Ada.Text_IO.Standard_Error,
            Item => "Unknown headline: """ & Item & """");
         raise Constraint_Error;
      end if;
   end Value;

   use
     Ada.Text_IO,
     Ada.Strings.Unbounded,
     Ada.Strings.Unbounded.Text_IO;

   type Parts is (Head, Content);
   Headers : array (Headlines) of Unbounded_String;
   Line    : Unbounded_String;
   Part    : Parts := Content;
begin
   while not End_Of_File loop
      Line := Get_Line;

      case Part is
         when Head =>
            if Length (Line) = 0 then
               for Headline in Headers'Range loop
                  if Length (Headers (Headline)) > 0 then
                     Put_Line (Headers (Headline));
                     Headers (Headline) := Null_Unbounded_String;
                  end if;
               end loop;
               New_Line;
               Part := Content;
            else
               declare
                  Field : constant Headlines :=
                            Value (Slice (Line, 1, Index (Line, ":")));
               begin
                  if Length (Headers (Field)) > 0 then
                     Append (Headers (Field), Ada.Characters.Latin_1.LF);
                  end if;
                  Append (Headers (Field), Line);
               end;
            end if;
         when Content =>
            if Is_Headline (Line) then
               for Headline in Headers'Range loop
                  if Length (Headers (Headline)) > 0 then
                     Put_Line (Headers (Headline));
                     Headers (Headline) := Null_Unbounded_String;
                  end if;
               end loop;
               Part := Head;
               Headers (Value (Slice (Line, 1, Index (Line, ":")))) := Line;
            else
               Put_Line (Line);
            end if;
      end case;
   end loop;
end Reorder_Headers;
