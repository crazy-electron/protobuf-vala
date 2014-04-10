using Google.Protobuf;

private int n_tests = 0;
private int n_passed = 0;

public static int main (string[] args)
{
    check_decode_varint ("", 0, true);
    check_decode_varint ("00", 0);
    check_decode_varint ("01", 1);
    check_decode_varint ("03", 3);
    check_decode_varint ("7F", 127);
    check_decode_varint ("FF", 0, true);
    check_decode_varint ("8001", 128);
    check_decode_varint ("8E02", 270);
    check_decode_varint ("FF7F", 16383);
    check_decode_varint ("808001", 16384);
    check_decode_varint ("9EA705", 86942);
    check_decode_varint ("FFFFFF07", 0xFFFFFF);
    check_decode_varint ("FFFFFFFF0F", 0xFFFFFFFF);
    check_decode_varint ("FFFFFFFFFFFFFFFFFF01", 0xFFFFFFFFFFFFFFFF);

    check_decode_double ("", 0d, true);
    check_decode_double ("00", 0d, true);
    check_decode_double ("00000000000000", 0d, true);
    check_decode_double ("0000000000000000", 0d);
    check_decode_double ("0000000000000080", -0d);
    check_decode_double ("000000000000F03F", 1d);
    check_decode_double ("000000000000F0BF", -1d);
    check_decode_double ("FFFFFFFFFFFFEF7F", double.MAX);
    check_decode_double ("FFFFFFFFFFFFEFFF", -double.MAX);
    check_decode_double ("000000000000F07F", double.INFINITY);
    check_decode_double ("000000000000F0FF", -double.INFINITY);

    check_decode_float ("", 0f, true);
    check_decode_float ("00", 0f, true);
    check_decode_float ("000000", 0f, true);
    check_decode_float ("00000000", 0f);
    check_decode_float ("00000080", -0f);
    check_decode_float ("0000803F", 1f);
    check_decode_float ("000080BF", -1f);
    check_decode_float ("FFFF7F7F", float.MAX);
    check_decode_float ("FFFF7FFF", -float.MAX);
    check_decode_float ("0000807F", float.INFINITY);
    check_decode_float ("000080FF", -float.INFINITY);
    check_decode_float ("0000203E", 0.15625f);

    check_decode_int64 ("00", 0);
    check_decode_int64 ("01", 1);
    check_decode_int64 ("FFFFFFFFFFFFFFFFFF01", -1);
    check_decode_int64 ("FFFFFFFFFFFFFFFF7F", int64.MAX);
    check_decode_int64 ("80808080808080808001", int64.MIN);

    check_decode_uint64 ("00", 0);
    check_decode_uint64 ("01", 1);
    check_decode_uint64 ("FFFFFFFFFFFFFFFFFF01", uint64.MAX);

    check_decode_int32 ("00", 0);
    check_decode_int32 ("01", 1);
    check_decode_int32 ("FFFFFFFFFFFFFFFFFF01", -1);
    check_decode_int32 ("FFFFFFFF07", int32.MAX);
    check_decode_int32 ("80808080F8FFFFFFFF01", int32.MIN);

    check_decode_fixed64 ("0000000000000000", 0);
    check_decode_fixed64 ("0100000000000000", 1);
    check_decode_fixed64 ("EFCDAB8967452301", 0x0123456789ABCDEF);
    check_decode_fixed64 ("FFFFFFFFFFFFFFFF", uint64.MAX);

    check_decode_fixed32 ("00000000", 0);
    check_decode_fixed32 ("01000000", 1);
    check_decode_fixed32 ("67452301", 0x01234567);
    check_decode_fixed32 ("FFFFFFFF", uint32.MAX);

    check_decode_bool ("", false, true);
    check_decode_bool ("00", false);
    check_decode_bool ("01", true);
    check_decode_bool ("7F", true);
    check_decode_bool ("FF", false, true);

    check_decode_string ("", 0, "");
    check_decode_string ("", 1, "", true);
    check_decode_string ("31", 1, "1");
    check_decode_string ("31", 3, "", true);
    check_decode_string ("313233", 3, "123");
    check_decode_string ("313233", 5, "", true);

    check_decode_bytes ("", 0, "");
    check_decode_bytes ("", 1, "", true);
    check_decode_bytes ("AA", 1, "AA");
    check_decode_bytes ("AA", 3, "", true);
    check_decode_bytes ("AABBCC", 3, "AABBCC");
    check_decode_bytes ("AABBCC", 5, "", true);

    check_decode_uint32 ("00", 0);
    check_decode_uint32 ("01", 1);
    check_decode_uint32 ("FFFFFFFF0F", uint32.MAX);

    check_decode_sfixed32 ("00000000", 0);
    check_decode_sfixed32 ("01000000", 1);
    check_decode_sfixed32 ("FFFFFFFF", -1);
    check_decode_sfixed32 ("00000080", int32.MIN);
    check_decode_sfixed32 ("FFFFFF7F", int32.MAX);

    check_decode_sfixed64 ("0000000000000000", 0);
    check_decode_sfixed64 ("0100000000000000", 1);
    check_decode_sfixed64 ("FFFFFFFFFFFFFFFF", -1);
    check_decode_sfixed64 ("0000000000000080", int64.MIN);
    check_decode_sfixed64 ("FFFFFFFFFFFFFF7F", int64.MAX);

    check_decode_sint32 ("00", 0);
    check_decode_sint32 ("02", 1);
    check_decode_sint32 ("04", 2);
    check_decode_sint32 ("01", -1);
    check_decode_sint32 ("03", -2);
    check_decode_sint32 ("FEFFFFFF0F", int32.MAX);
    check_decode_sint32 ("FFFFFFFF0F", int32.MIN);

    check_decode_sint64 ("00", 0);
    check_decode_sint64 ("02", 1);
    check_decode_sint64 ("04", 2);
    check_decode_sint64 ("01", -1);
    check_decode_sint64 ("03", -2);
    check_decode_sint64 ("FEFFFFFFFFFFFFFFFF01", int64.MAX);
    check_decode_sint64 ("FFFFFFFFFFFFFFFFFF01", int64.MIN);

    check_decode_enum_message ("08011801", Test.Vala.Enum.ONE, Test.Vala.Enum.ONE, Test.Vala.Enum.ONE);
    check_decode_enum_message ("08021002", Test.Vala.Enum.TWO, Test.Vala.Enum.TWO, Test.Vala.Enum.TWO);
    check_decode_enum_message ("080310031803", Test.Vala.Enum.THREE, Test.Vala.Enum.THREE, Test.Vala.Enum.THREE);
    
    check_decode_message ("08FFFFFFFFFFFFFFFFFF011001180125010000002DFFFFFFFF30FFFFFFFFFFFFFFFFFF013801400149010000000000000051FFFFFFFFFFFFFFFF580160016A04544553547202BEEF79000000000000F03F85010000803F");

    check_decode_required_message ("", 0, "", true);
    check_decode_required_message ("0800", 0, "", true);
    check_decode_required_message ("1200", 0, "", true);
    check_decode_required_message ("08001200", 0, "");
    check_decode_required_message ("0802120454455354", 1, "TEST");
    check_decode_required_message ("08021204544553541A03313233", 1, "TEST");

    check_decode_required_message_reencode ("0802120454455354");
    check_decode_required_message_reencode ("0802120454455354180125010000002DFFFFFFFF30FFFFFFFFFFFFFFFFFF013801400149010000000000000051FFFFFFFFFFFFFFFF580160016A04544553547202BEEF79000000000000F03F85010000803F");

    check_decode_optional_message ("", 0, "");
    check_decode_optional_message ("0802", 1, "");
    check_decode_optional_message ("120454455354", 0, "TEST");
    check_decode_optional_message ("0802120454455354", 1, "TEST");
    check_decode_optional_message_twice ("120454455354", "0802", 1, "");

    check_decode_optional_defaults_message ("08001200", 0, "");
    check_decode_optional_defaults_message ("1200", 1, "");
    check_decode_optional_defaults_message ("0800", 0, "TEST");
    check_decode_optional_defaults_message ("", 1, "TEST");

    check_decode_repeated_message ("", "");
    check_decode_repeated_message ("0801", "1");
    check_decode_repeated_message ("0801080208030804", "1 2 3 4");

    check_decode_repeated_packed_message ("", "");
    check_decode_repeated_packed_message ("0A0101", "1");
    check_decode_repeated_packed_message ("0A0401020304", "1 2 3 4");
    check_decode_repeated_packed_message ("0A0201020A020304", "1 2 3 4");

    check_decode_required_nested_message ("", 0, true);
    check_decode_required_nested_message ("0A00", 0, true);
    check_decode_required_nested_message ("0A020801", 1);

    check_decode_optional_nested_message ("", null);
    check_decode_optional_nested_message ("0A00", 0, true);
    check_decode_optional_nested_message ("0A020801", 1);

    check_decode_repeated_nested_message ("",  "");
    check_decode_repeated_nested_message ("0A00", "", true);
    check_decode_repeated_nested_message ("0A020801", "1");
    check_decode_repeated_nested_message ("0A0208010A0208020A020803", "1 2 3");

    check_decode_existing_buffer ("", 0, -1, 0, true);
    check_decode_existing_buffer ("01", 0, 0, 0, true);
    check_decode_existing_buffer ("01", 0, -1, 1);
    check_decode_existing_buffer ("01", 0, 1, 1);
    check_decode_existing_buffer ("01FFFFFF", 0, 1, 1);
    check_decode_existing_buffer ("FF01FFFF", 1, 1, 1);
    check_decode_existing_buffer ("FFFFFF01", 3, -1, 1);
    check_decode_existing_buffer ("FFFFFF01", 4, -1, 0, true);

    if (n_passed != n_tests)
    {
        stderr.printf ("Failed %d/%d tests\n", n_tests - n_passed, n_tests);
        return Posix.EXIT_FAILURE;
    }
    
    stderr.printf ("Passed all %d tests\n", n_tests);

    return Posix.EXIT_SUCCESS;
}

private void check_decode_varint (string data, uint64 expected, bool error = false)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_varint ();

    n_tests++;

    if (!error && !buffer.error && result == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_varint (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_varint (\"%s\") -> %" + uint64.FORMAT + ", expected %" + uint64.FORMAT + "\n", data, result, expected);
}

private void check_decode_double (string data, double expected, bool error = false)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_double ();

    n_tests++;
    if (!error && !buffer.error && result == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_double (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_double (\"%s\") -> %f, expected %f\n", data, result, expected);
}

private void check_decode_float (string data, float expected, bool error = false)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_float ();

    n_tests++;
    if (!error && !buffer.error && result == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_float (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_float (\"%s\") -> %f, expected %f\n", data, result, expected);
}

private void check_decode_int64 (string data, int64 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_int64 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_int64 (\"%s\") -> %" + int64.FORMAT + ", expected %" + int64.FORMAT + "\n", data, result, expected);
}

private void check_decode_uint64 (string data, uint64 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_uint64 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_uint64 (\"%s\") -> %" + uint64.FORMAT + ", expected %" + uint64.FORMAT + "\n", data, result, expected);
}

private void check_decode_int32 (string data, int32 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_int32 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_int32 (\"%s\") -> %d, expected %d\n", data, result, expected);
}

private void check_decode_fixed64 (string data, uint64 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_fixed64 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_fixed64 (\"%s\") -> %" + uint64.FORMAT + ", expected %" + uint64.FORMAT + "\n", data, result, expected);
}

private void check_decode_fixed32 (string data, uint32 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_fixed32 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_fixed32 (\"%s\") -> %u, expected %u\n", data, result, expected);
}

private void check_decode_bool (string data, bool expected, bool error = false)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_bool ();

    n_tests++;
    if (!error && !buffer.error && result == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_bool (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_bool (\"%s\") -> %s, expected %s\n", data, result.to_string (), expected.to_string ());
}

private void check_decode_string (string data, size_t length, string expected, bool error = false)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_string (length);

    n_tests++;
    if (!error && !buffer.error && result == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_string (\"%s\", %zu) -> error %s, expected error %s\n", data, length, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_string (\"%s\", %zu) -> \"%s\", expected \"%s\"\n", data, length, result, expected);
}

private void check_decode_bytes (string data, size_t length, string expected, bool error = false)
{
    var buffer = string_to_buffer (data);
    var r = buffer.decode_bytes (length);
    var result = array_to_string (r.data);

    n_tests++;
    if (!error && !buffer.error && result == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_bytes (\"%s\", %zu) -> error %s, expected error %s\n", data, length, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_bytes (\"%s\", %zu) -> \"%s\", expected \"%s\"\n", data, length, result, expected);
}

private void check_decode_uint32 (string data, uint32 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_uint32 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_uint32 (\"%s\") -> %u, expected %u\n", data, result, expected);
}

private void check_decode_sfixed32 (string data, int32 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_sfixed32 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_sfixed32 (\"%s\") -> %i, expected %i\n", data, result, expected);
}

private void check_decode_sfixed64 (string data, int64 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_sfixed64 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_sfixed64 (\"%s\") -> %" + int64.FORMAT + ", expected %" + int64.FORMAT + "\n", data, result, expected);
}

private void check_decode_sint32 (string data, int32 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_sint32 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_sint32 (\"%s\") -> %d, expected %d\n", data, result, expected);
}

private void check_decode_sint64 (string data, int64 expected)
{
    var buffer = string_to_buffer (data);
    var result = buffer.decode_sint64 ();

    n_tests++;
    if (result == expected)
        n_passed++;
    else
        stderr.printf ("decode_sint64 (\"%s\") -> %" + int64.FORMAT + ", expected %" + int64.FORMAT + "\n", data, result, expected);
}

private void check_decode_enum_message (string data, Test.Vala.Enum enum_value, Test.Vala.Enum enum_value_o, Test.Vala.Enum enum_value_od, bool error = false)
{
    var result = new Test.Vala.EnumMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    n_tests++;
    if (!error && !buffer.error && result.enum_value == enum_value && result.enum_value_o == enum_value_o && result.enum_value_od == enum_value_od)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_enum_message (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_enum_message (\"%s\") -> enum_value=%s enum_value_o=%s enum_value_od=%s, expected enum_value=%s enum_value_o=%s enum_value_od=%s\n",
                       data, Test.Vala.Enum_to_string (result.enum_value), Test.Vala.Enum_to_string (result.enum_value_o), Test.Vala.Enum_to_string (result.enum_value_od), Test.Vala.Enum_to_string (enum_value), Test.Vala.Enum_to_string (enum_value_o), Test.Vala.Enum_to_string (enum_value_od));
}

private void check_decode_message (string data, bool error = false)
{
    var result = new Test.Vala.Message ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);
    var result_value_bytes = array_to_string (result.value_bytes.data);

    var matches = result.value_int32 == -1 &&
                  result.value_uint32 == 1 &&
                  result.value_sint32 == -1 &&
                  result.value_fixed32 == 1 &&
                  result.value_sfixed32 == -1 &&
                  result.value_int64 == -1 &&
                  result.value_uint64 == 1 &&
                  result.value_sint64 == -1 &&
                  result.value_fixed64 == 1 &&
                  result.value_sfixed64 == -1 &&
                  result.value_bool == true &&
                  result.value_enum == Test.Vala.Enum.ONE &&
                  result.value_string == "TEST" &&
                  result_value_bytes == "BEEF" &&
                  result.value_double == 1.0d &&
                  result.value_float == 1.0f;

    n_tests++;
    if (!error && !buffer.error && matches)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_message (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_message (\"%s\") -> ?\n", data);
}

private void check_decode_required_message (string data, int32 int_value, string string_value, bool error = false)
{
    var result = new Test.Vala.RequiredMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    n_tests++;
    if (!error && !buffer.error && result.int_value == int_value && result.string_value == string_value)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_required_message (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_required_message (\"%s\") -> int_value=%d string_value=\"%s\", expected int_value=%d string_value=\"%s\"\n",
                       data, result.int_value, result.string_value, int_value, string_value);
}

private void check_decode_required_message_reencode (string data)
{
    var result = new Test.Vala.RequiredMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    var encode_buffer = new EncodeBuffer ();
    result.encode (encode_buffer);

    var encode_data = array_to_string (encode_buffer.data);

    n_tests++;
    if (encode_data == data)
        n_passed++;
    else
        stderr.printf ("decode_required_message_reencode (\"%s\") -> \"%s\"\n", data, encode_data);
}

private void check_decode_optional_message (string data, int32 int_value, string string_value)
{
    var result = new Test.Vala.OptionalMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    n_tests++;
    if (result.int_value == int_value && result.string_value == string_value)
        n_passed++;
    else
        stderr.printf ("decode_optional_message (\"%s\") -> int_value=%d string_value=\"%s\", expected int_value=%d string_value=\"%s\"\n",
                       data, result.int_value, result.string_value, int_value, string_value);
}

private void check_decode_optional_message_twice (string data1, string data2, int32 int_value, string string_value)
{
    var result = new Test.Vala.OptionalMessage ();
    var buffer1 = string_to_buffer (data1);
    result.decode (buffer1);
    var buffer2 = string_to_buffer (data2);
    result.decode (buffer2);

    n_tests++;
    if (result.int_value == int_value && result.string_value == string_value)
        n_passed++;
    else
        stderr.printf ("decode_optional_message_twice (\"%s\", \"%s\") -> int_value=%d string_value=\"%s\", expected int_value=%d string_value=\"%s\"\n",
                       data1, data2, result.int_value, result.string_value, int_value, string_value);
}

private void check_decode_optional_defaults_message (string data, int32 int_value, string string_value)
{
    var result = new Test.Vala.OptionalDefaultsMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    n_tests++;
    if (result.int_value == int_value && result.string_value == string_value)
        n_passed++;
    else
        stderr.printf ("decode_optional_defaults_message (\"%s\") -> int_value=%d string_value=\"%s\", expected int_value=%d string_value=\"%s\"\n",
                       data, result.int_value, result.string_value, int_value, string_value);
}

private void check_decode_repeated_message (string data, string expected)
{
    var result = new Test.Vala.RepeatedMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    var result_value = "";
    foreach (var v in result.value)
    {
        if (result_value != "")
            result_value += " ";
        result_value += "%u".printf (v);
    }

    n_tests++;
    if (result_value == expected)
        n_passed++;
    else
        stderr.printf ("decode_repeated_message (\"%s\") -> %s, expected %s\n", data, result_value, expected);
}

private void check_decode_repeated_packed_message (string data, string expected)
{
    var result = new Test.Vala.RepeatedPackedMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    var result_value = "";
    foreach (var v in result.value)
    {
        if (result_value != "")
            result_value += " ";
        result_value += "%u".printf (v);
    }

    n_tests++;
    if (result_value == expected)
        n_passed++;
    else
        stderr.printf ("decode_repeated_packed_message (\"%s\") -> %s, expected %s\n", data, result_value, expected);
}

private void check_decode_required_nested_message (string data, uint32 value, bool error = false)
{
    var result = new Test.Vala.RequiredNestedMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    n_tests++;
    if (!error && !buffer.error && result.child != null && result.child.value == value)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_required_nested_message (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else if (result.child == null)
        stderr.printf ("decode_required_nested_message (\"%s\") -> child=null, expected child.value=%u\n", data, value);
    else
        stderr.printf ("decode_required_nested_message (\"%s\") -> child.value=%ud, expected child.value=%u\n", data, result.child.value, value);
}

private void check_decode_optional_nested_message (string data, uint32? value, bool error = false)
{
    var result = new Test.Vala.OptionalNestedMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    uint32? child_value = null;
    if (result.child != null)
        child_value = result.child.value;

    n_tests++;
    if (!error && !buffer.error && child_value == value)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_optional_nested_message (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else if (result.child == null)
        stderr.printf ("decode_optional_nested_message (\"%s\") -> child=null, expected child.value=%u\n", data, value);
    else if (value == null)
        stderr.printf ("decode_optional_nested_message (\"%s\") -> child.value=%ud, expected child=null\n", data, result.child.value);
    else
        stderr.printf ("decode_optional_nested_message (\"%s\") -> child.value=%ud, expected child.value=%u\n", data, result.child.value, value);
}

private void check_decode_repeated_nested_message (string data, string expected, bool error = false)
{
    var result = new Test.Vala.RepeatedNestedMessage ();
    var buffer = string_to_buffer (data);
    result.decode (buffer);

    var result_value = "";
    foreach (var v in result.children)
    {
        if (result_value != "")
            result_value += " ";
        result_value += "%u".printf (v.value);
    }

    n_tests++;
    if (!error && !buffer.error && result_value == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_repeated_nested_message (\"%s\") -> error %s, expected error %s\n", data, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_repeated_nested_message (\"%s\") -> \"%s\", expected \"%s\"\n", data, result_value, expected);
}

private void check_decode_existing_buffer (string data, size_t offset, ssize_t length, uint64 expected, bool error = false)
{
    var b = new uint8[data.length / 2];
    for (var i = 0; i < b.length; i++)
        b[i] = str_to_int (data[i*2]) << 4 | str_to_int (data[i*2+1]);
    var buffer = new DecodeBuffer (b, offset, length);
    var result = buffer.decode_varint ();

    n_tests++;
    if (!error && !buffer.error && result == expected)
        n_passed++;
    else if (error && buffer.error)
        n_passed++;
    else if (buffer.error != error)
        stderr.printf ("decode_existing_buffer (\"%s\", %u, %i) -> error %s, expected error %s\n", data, (uint) offset, (int) length, buffer.error.to_string (), error.to_string ());
    else
        stderr.printf ("decode_existing_buffer (\"%s\", %u, %i) -> %u, expected %u\n", data, (uint) offset, (int) length, (uint) result, (uint) expected);
}

private DecodeBuffer string_to_buffer (string data)
{
    var value = new DecodeBuffer.sized (data.length / 2);

    for (var i = 0; i < value.buffer.length; i++)
        value.buffer[i] = str_to_int (data[i*2]) << 4 | str_to_int (data[i*2+1]);

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

private string array_to_string (uint8[] value)
{
    var text = "";

    for (var i = 0; i < value.length; i++)
        text += "%02X".printf (value[i]);

    return text;
}
