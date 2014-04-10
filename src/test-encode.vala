using Google.Protobuf;

private int n_tests = 0;
private int n_passed = 0;

public static int main (string[] args)
{
    check_encode_varint (0, "00");
    check_encode_varint (1, "01");
    check_encode_varint (3, "03");
    check_encode_varint (127, "7F");
    check_encode_varint (128, "8001");
    check_encode_varint (270, "8E02");
    check_encode_varint (16383, "FF7F");
    check_encode_varint (16384, "808001");
    check_encode_varint (86942, "9EA705");
    check_encode_varint (0xFFFFFFFF, "FFFFFFFF0F");
    check_encode_varint (0xFFFFFFFFFFFFFFFF, "FFFFFFFFFFFFFFFFFF01");

    check_encode_double (0f, "0000000000000000");
    check_encode_double (-0f, "0000000000000080");
    check_encode_double (1f, "000000000000F03F");
    check_encode_double (-1f, "000000000000F0BF");
    check_encode_double (double.MAX, "FFFFFFFFFFFFEF7F");
    check_encode_double (-double.MAX, "FFFFFFFFFFFFEFFF");
    check_encode_double (double.INFINITY, "000000000000F07F");
    check_encode_double (-double.INFINITY, "000000000000F0FF");

    check_encode_float (0f, "00000000");
    check_encode_float (-0f, "00000080");
    check_encode_float (1f, "0000803F");
    check_encode_float (-1f, "000080BF");
    check_encode_float (float.MAX, "FFFF7F7F");
    check_encode_float (-float.MAX, "FFFF7FFF");
    check_encode_float (float.INFINITY, "0000807F");
    check_encode_float (-float.INFINITY, "000080FF");
    check_encode_float (0.15625f, "0000203E");

    check_encode_int64 (0, "00");
    check_encode_int64 (1, "01");
    check_encode_int64 (-1, "FFFFFFFFFFFFFFFFFF01");
    check_encode_int64 (int64.MAX, "FFFFFFFFFFFFFFFF7F");
    check_encode_int64 (int64.MIN, "80808080808080808001");

    check_encode_uint64 (0, "00");
    check_encode_uint64 (1, "01");
    check_encode_uint64 (uint64.MAX, "FFFFFFFFFFFFFFFFFF01");

    check_encode_int32 (0, "00");
    check_encode_int32 (1, "01");
    check_encode_int32 (-1, "FFFFFFFFFFFFFFFFFF01");
    check_encode_int32 (int32.MAX, "FFFFFFFF07");
    check_encode_int32 (int32.MIN, "80808080F8FFFFFFFF01");

    check_encode_fixed64 (0, "0000000000000000");
    check_encode_fixed64 (1, "0100000000000000");
    check_encode_fixed64 (0x0123456789ABCDEF, "EFCDAB8967452301");
    check_encode_fixed64 (uint64.MAX, "FFFFFFFFFFFFFFFF");

    check_encode_fixed32 (0, "00000000");
    check_encode_fixed32 (1, "01000000");
    check_encode_fixed32 (0x01234567, "67452301");
    check_encode_fixed32 (uint32.MAX, "FFFFFFFF");

    check_encode_bool (false, "00");
    check_encode_bool (true, "01");

    check_encode_string ("", "");
    check_encode_string ("123", "313233");

    check_encode_bytes ("", "");
    check_encode_bytes ("AA", "AA");
    check_encode_bytes ("AABBCC", "AABBCC");

    check_encode_uint32 (0, "00");
    check_encode_uint32 (1, "01");
    check_encode_uint32 (uint32.MAX, "FFFFFFFF0F");

    check_encode_sfixed32 (0, "00000000");
    check_encode_sfixed32 (1, "01000000");
    check_encode_sfixed32 (-1, "FFFFFFFF");
    check_encode_sfixed32 (int32.MIN, "00000080");
    check_encode_sfixed32 (int32.MAX, "FFFFFF7F");

    check_encode_sfixed64 (0, "0000000000000000");
    check_encode_sfixed64 (1, "0100000000000000");
    check_encode_sfixed64 (-1, "FFFFFFFFFFFFFFFF");
    check_encode_sfixed64 (int64.MIN, "0000000000000080");
    check_encode_sfixed64 (int64.MAX, "FFFFFFFFFFFFFF7F");

    check_encode_sint32 (0, "00");
    check_encode_sint32 (1, "02");
    check_encode_sint32 (2, "04");
    check_encode_sint32 (-1, "01");
    check_encode_sint32 (-2, "03");
    check_encode_sint32 (int32.MAX, "FEFFFFFF0F");
    check_encode_sint32 (int32.MIN, "FFFFFFFF0F");

    check_encode_sint64 (0, "00");
    check_encode_sint64 (1, "02");
    check_encode_sint64 (2, "04");
    check_encode_sint64 (-1, "01");
    check_encode_sint64 (-2, "03");
    check_encode_sint64 (int64.MAX, "FEFFFFFFFFFFFFFFFF01");
    check_encode_sint64 (int64.MIN, "FFFFFFFFFFFFFFFFFF01");

    check_encode_enum_message (Test.Vala.Enum.ONE, Test.Vala.Enum.ONE, Test.Vala.Enum.ONE, "08011801");
    check_encode_enum_message (Test.Vala.Enum.TWO, Test.Vala.Enum.TWO, Test.Vala.Enum.TWO, "08021002");
    check_encode_enum_message (Test.Vala.Enum.THREE, Test.Vala.Enum.THREE, Test.Vala.Enum.THREE, "080310031803");

    /* Check buffer resizing works */
    check_buffer_resize (0, 0);
    check_buffer_resize (0, 1);
    check_buffer_resize (2, 0);
    check_buffer_resize (2, 1);
    check_buffer_resize (2, 2);
    check_buffer_resize (2, 3);
    check_buffer_resize (8, 1);

    check_encode_message ("08FFFFFFFFFFFFFFFFFF011001180125010000002DFFFFFFFF30FFFFFFFFFFFFFFFFFF013801400149010000000000000051FFFFFFFFFFFFFFFF580160016A04544553547202BEEF79000000000000F03F85010000803F");

    check_encode_required_message (0, "", "08001200");
    check_encode_required_message (1, "TEST", "0802120454455354");

    check_encode_optional_message (0, "", "");
    check_encode_optional_message (1, "", "0802");
    check_encode_optional_message (0, "TEST", "120454455354");
    check_encode_optional_message (1, "TEST", "0802120454455354");

    check_encode_optional_defaults_message (0, "", "08001200");
    check_encode_optional_defaults_message (1, "", "1200");
    check_encode_optional_defaults_message (0, "TEST", "0800");
    check_encode_optional_defaults_message (1, "TEST", "");

    check_encode_repeated_message ("", "");
    check_encode_repeated_message ("1", "0801");
    check_encode_repeated_message ("1 2 3 4", "0801080208030804");

    check_encode_repeated_packed_message ("", "");
    check_encode_repeated_packed_message ("1", "0A0101");
    check_encode_repeated_packed_message ("1 2 3 4", "0A0401020304");

    check_encode_required_nested_message (1, "0A020801");

    check_encode_optional_nested_message (null, "");
    check_encode_optional_nested_message (1, "0A020801");

    check_encode_repeated_nested_message ("", "");
    check_encode_repeated_nested_message ("1", "0A020801");
    check_encode_repeated_nested_message ("1 2 3", "0A0208010A0208020A020803");

    if (n_passed != n_tests)
    {
        stderr.printf ("Failed %d/%d tests\n", n_tests - n_passed, n_tests);
        return Posix.EXIT_FAILURE;
    }
    
    stderr.printf ("Passed all %d tests\n", n_tests);

    return Posix.EXIT_SUCCESS;
}

private void check_encode_varint (uint64 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_varint (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_varint (%" + uint64.FORMAT + ") -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_double (double value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_double (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_double (%f) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_float (float value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_float (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_float (%f) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_int64 (int64 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_int64 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_int64 (%" + int64.FORMAT + ") -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_uint64 (uint64 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_uint64 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_uint64 (%" + uint64.FORMAT + ") -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_int32 (int32 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_int32 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_int32 (%d) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_fixed64 (uint64 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_fixed64 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_fixed64 (%" + uint64.FORMAT + ") -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_fixed32 (uint32 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_fixed32 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_fixed32 (%u) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_bool (bool value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_bool (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_bool (%s) -> \"%s\", expected \"%s\"\n", value.to_string (), result, expected);
}

private void check_encode_string (string value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_string (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_string (%s) -> \"%s\", expected \"%s\"\n", value.to_string (), result, expected);
}

private void check_encode_bytes (string value, string expected)
{
    var v = new ByteArray.take (string_to_array (value));

    var buffer = new EncodeBuffer ();
    buffer.encode_bytes (v);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_bytes (%s) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_uint32 (uint32 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_uint32 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_uint32 (%u) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_sfixed32 (int32 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_sfixed32 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_sfixed32 (%i) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_sfixed64 (int64 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_sfixed64 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_sfixed64 (%" + int64.FORMAT + ") -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_sint32 (int32 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_sint32 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_sint32 (%d) -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_sint64 (int64 value, string expected)
{
    var buffer = new EncodeBuffer ();
    buffer.encode_sint64 (value);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_sint64 (%" + int64.FORMAT + ") -> \"%s\", expected \"%s\"\n", value, result, expected);
}

private void check_encode_enum_message (Test.Vala.Enum enum_value, Test.Vala.Enum enum_value_o, Test.Vala.Enum enum_value_od, string expected)
{
    var value = new Test.Vala.EnumMessage ();
    value.enum_value = enum_value;
    value.enum_value_o = enum_value_o;
    value.enum_value_od = enum_value_od;

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_enum_message (enum_value=%s enum_value_o=%s enum_value_od=%s) -> \"%s\", expected \"%s\"\n",
                       Test.Vala.Enum_to_string (enum_value), Test.Vala.Enum_to_string (enum_value_o), Test.Vala.Enum_to_string (enum_value_od), result, expected);
}

private void check_buffer_resize (size_t value_length, size_t buffer_length)
{
    var buffer = new EncodeBuffer (buffer_length);
    var value = "";
    for (var i = 0; i < value_length; i++)
        value += "FF";
    var v = new ByteArray.take (string_to_array (value));
    buffer.encode_bytes (v);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == value)
        n_passed++;
    else
        stderr.printf ("buffer_resize (%zu, %zu) -> \"%s\", expected \"%s\"\n", value_length, buffer_length, result, value);
}

private void check_encode_message (string expected)
{
    var value = new Test.Vala.Message ();
    value.value_int32 = -1;
    value.value_uint32 = 1;
    value.value_sint32 = -1;
    value.value_fixed32 = 1;
    value.value_sfixed32 = -1;
    value.value_int64 = -1;
    value.value_uint64 = 1;
    value.value_sint64 = -1;
    value.value_fixed64 = 1;
    value.value_sfixed64 = -1;
    value.value_bool = true;
    value.value_enum = Test.Vala.Enum.ONE;
    value.value_string = "TEST";
    value.value_bytes = new ByteArray.take (string_to_array ("BEEF"));
    value.value_double = 1.0d;
    value.value_float = 1.0f;

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_message () -> \"%s\", expected \"%s\"\n", result, expected);
}

private void check_encode_required_message (int32 int_value, string string_value, string expected)
{
    var value = new Test.Vala.RequiredMessage ();
    value.int_value = int_value;
    value.string_value = string_value;

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_required_message (int_value=%d string_value=\"%s\") -> \"%s\", expected \"%s\"\n", int_value, string_value, result, expected);
}

private void check_encode_optional_message (int32 int_value, string string_value, string expected)
{
    var value = new Test.Vala.OptionalMessage ();
    value.int_value = int_value;
    value.string_value = string_value;

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_optional_message (int_value=%d string_value=\"%s\") -> \"%s\", expected \"%s\"\n", int_value, string_value, result, expected);
}

private void check_encode_optional_defaults_message (int32 int_value, string string_value, string expected)
{
    var value = new Test.Vala.OptionalDefaultsMessage ();
    value.int_value = int_value;
    value.string_value = string_value;

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_optional_defaults_message (int_value=%d string_value=\"%s\") -> \"%s\", expected \"%s\"\n", int_value, string_value, result, expected);
}

private void check_encode_repeated_message (string repeated_value, string expected)
{
    var value = new Test.Vala.RepeatedMessage ();
    var values = repeated_value.split (" ");
    for (var i = 0; i < values.length; i++)
        value.value.append (int.parse (values[i]));

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_repeated_message (%s) -> \"%s\", expected \"%s\"\n", repeated_value, result, expected);
}

private void check_encode_repeated_packed_message (string repeated_value, string expected)
{
    var value = new Test.Vala.RepeatedPackedMessage ();
    var values = repeated_value.split (" ");
    for (var i = 0; i < values.length; i++)
        value.value.append (int.parse (values[i]));

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_repeated_packed_message (%s) -> \"%s\", expected \"%s\"\n", repeated_value, result, expected);
}

private void check_encode_required_nested_message (uint32 v, string expected)
{
    var value = new Test.Vala.RequiredNestedMessage ();
    value.child.value = v;

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_required_nested_message (value=%u) -> \"%s\", expected \"%s\"\n", v, result, expected);
}

private void check_encode_optional_nested_message (uint32? v, string expected)
{
    var value = new Test.Vala.OptionalNestedMessage ();
    if (v != null)
    {
        value.child = new Test.Vala.ChildMessage ();
        value.child.value = v;
    }

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else if (v == null)
        stderr.printf ("encode_optional_nested_message (value=null) -> \"%s\", expected \"%s\"\n", result, expected);
    else
        stderr.printf ("encode_optional_nested_message (value=%u) -> \"%s\", expected \"%s\"\n", v, result, expected);
}

private void check_encode_repeated_nested_message (string repeated_value, string expected)
{
    var value = new Test.Vala.RepeatedNestedMessage ();
    var values = repeated_value.split (" ");
    for (var i = 0; i < values.length; i++)
    {
        var m = new Test.Vala.ChildMessage ();
        m.value = int.parse (values[i]);
        value.children.append (m);
    }

    var buffer = new EncodeBuffer ();
    value.encode (buffer);
    var result = buffer_to_string (buffer);

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("encode_repeated_nested_message (%s) -> \"%s\", expected \"%s\"\n", repeated_value, result, expected);
}

private string buffer_to_string (EncodeBuffer buffer)
{
    var value = "";

    var data = buffer.data;
    for (var i = 0; i < data.length; i++)
        value += "%02X".printf (data[i]);

    return value;
}

private uint8[] string_to_array (string data)
{
    var value = new uint8[data.length / 2];

    for (var i = 0; i < value.length; i++)
        value[i] = str_to_int (data[i*2]) << 4 | str_to_int (data[i*2+1]);

    return value;
}

private uint8 str_to_int (char c)
{
    if (c >= '0' && c <= '9')
        return c - '0';
    else if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    else if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    else
        return 0;
}
