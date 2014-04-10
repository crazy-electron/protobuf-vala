namespace Google.Protobuf
{
    public abstract class Message
    {
        protected List<UnknownField> unknown_fields;
        public abstract size_t encode (Google.Protobuf.EncodeBuffer buffer);
        public abstract bool decode (Google.Protobuf.DecodeBuffer buffer, ssize_t data_length = -1);
        public abstract string to_string (string indent = "");
    }

    public class UnknownField
    {
        public uint64 key;
        public uint64 varint;
        public ByteArray data;
    }

    public class DecodeBuffer
    {
        public unowned uint8[] buffer;
        private uint8[]? internal_buffer;
        public size_t read_index;
        public bool error;
        
        public DecodeBuffer (uint8[] buffer, size_t offset = 0, ssize_t length = -1)
        {
            if (offset > buffer.length)
                offset = buffer.length;
            if (length < 0)
                length = (ssize_t) (buffer.length - offset);
            else if (offset + length > buffer.length)
                length = (ssize_t) (buffer.length - offset);
            this.buffer = (uint8[]) ((uint8*) buffer + offset);
            this.buffer.length = (int) length;
        }

        public DecodeBuffer.sized (size_t size)
        {
            internal_buffer = new uint8[size];
            buffer = internal_buffer;
            reset ();
        }
        
        public void reset ()
        {
            read_index = 0;
            error = false;
        }

        public uint64 decode_varint ()
        {
            uint64 value = 0;
            var shift = 0;
    
            while (read_index < buffer.length)
            {
                var b = (uint64) buffer[read_index];
                read_index++;
                value |= (b & 0x7F) << shift;
                if ((b & 0x80) == 0)
                    return value;
                shift += 7;
            }

            error = true;
            return 0;
        }
    
        public double decode_double ()
        {
            var v = decode_fixed64 ();
            return *((double*) (&v));
        }
    
        public float decode_float ()
        {
            var v = decode_fixed32 ();
            return *((float*) (&v));
        }
    
        public int64 decode_int64 ()
        {
            var v = decode_varint ();
            return *((int64*) (&v));
        }
    
        public uint64 decode_uint64 ()
        {
            return decode_varint ();
        }
    
        public int32 decode_int32 ()
        {
            return (int32) decode_int64 ();
        }
    
        public uint64 decode_fixed64 ()
        {
            if (read_index + 8 > buffer.length)
            {
                read_index = buffer.length;
                error = true;
                return 0;
            }

            var v = (uint64) buffer[read_index] | (uint64) buffer[read_index+1] << 8 | (uint64) buffer[read_index+2] << 16 | (uint64) buffer[read_index+3] << 24 | (uint64) buffer[read_index+4] << 32 | (uint64) buffer[read_index+5] << 40 | (uint64) buffer[read_index+6] << 48 | (uint64) buffer[read_index+7] << 56;
            read_index += 8;
            return v;
        }
    
        public uint32 decode_fixed32 ()
        {
            if (read_index + 4 > buffer.length)
            {
                read_index = buffer.length;
                error = true;
                return 0;
            }

            var v = (uint32) buffer[read_index] | (uint32) buffer[read_index+1] << 8 | (uint32) buffer[read_index+2] << 16 | (uint32) buffer[read_index+3] << 24;
            read_index += 4;
            return v;
        }
    
        public bool decode_bool ()
        {
            return decode_varint () != 0;
        }
    
        public string decode_string (size_t length)
        {
            if (read_index + length > buffer.length)
            {
                read_index = buffer.length;
                error = true;
                return "";
            }

            var value = new GLib.StringBuilder.sized (length);
            for (var i = 0; i < length; i++)
                value.append_c ((char) buffer[read_index + i]);
            read_index += length;
    
            return value.str;
        }
    
        public GLib.ByteArray decode_bytes (size_t length)
        {
            if (read_index + length > buffer.length)
            {
                read_index = buffer.length;
                error = true;
                return new ByteArray ();
            }

            var data = new uint8[length];
            for (var i = 0; i < length; i++)
                data[i] = buffer[read_index + i];
            read_index += length;
    
            return new ByteArray.take (data);
        }
    
        public uint32 decode_uint32 ()
        {
            return (uint32) decode_varint ();
        }
    
        public int32 decode_sfixed32 ()
        {
            var v = decode_fixed32 ();
            return *((int32*) (&v));
        }
    
        public int64 decode_sfixed64 ()
        {
            var v = decode_fixed64 ();
            return *((int64*) (&v));
        }
    
        public int32 decode_sint32 ()
        {
            var value = (uint32) decode_varint ();
            var v = (int32) (value >> 1);
            if ((value & 0x1) != 0)
                return -(v + 1);
            else
                return v;
        }
    
        public int64 decode_sint64 ()
        {
            var value = (uint64) decode_varint ();
            var v = (int64) (value >> 1);
            if ((value & 0x1) != 0)
                return -(v + 1);
            else
                return v;
        }
    
        public UnknownField decode_unknown_field (uint64 key)
        {
            var value = new UnknownField ();
            value.key = key;
            var wire_type = key & 0x7;
            switch (wire_type)
            {
            case 0: //varint
                value.varint = decode_varint ();
                break;
            case 1: //64-bit
                value.data = decode_bytes (8);
                break;
            case 2: //length-delimited
                var length = decode_varint ();
                value.data = decode_bytes ((size_t) length);
                break;
            case 5: //32-bit
                value.data = decode_bytes (4);
                break;
            default: //FIXME: throw error
                GLib.stderr.printf ("Unknown wire type %" + uint64.FORMAT + "\n", wire_type);
                break;
            }

            return value;
        }
    }

    public class EncodeBuffer
    {
        private uint8[] buffer;
        public size_t write_index; // FIXME: Should be private

        public unowned uint8[] data
        {
            get
            {
                unowned uint8[] v = (uint8[]) ((uint8*) buffer + write_index);
                v.length = buffer.length - (int) write_index;
                return v;
            }
        }

        public EncodeBuffer (size_t size = 1024)
        {
            if (size < 1)
                size = 1;
            buffer = new uint8[size];
            reset ();
        }

        public void reset ()
        {
            write_index = buffer.length;
        }

        public size_t encode_varint (uint64 value)
        {
            var n_octets = 0;
            var v = value;
            do
            {
                v >>= 7;
                n_octets++;
            } while (v != 0);

            allocate (n_octets);
            write_index -= n_octets;

            v = value;
            for (var i = 0; i < n_octets - 1; i++)
            {
                buffer[write_index + i] = 0x80 | (uint8) (v & 0x7F);
                v >>= 7;
            }
            buffer[write_index + n_octets - 1] = (uint8) (v & 0x7F);

            return n_octets;
        }

        public size_t encode_double (double value)
        {
            return encode_fixed64 (*((uint64*) (&value)));
        }

        public size_t encode_float (float value)
        {
            return encode_fixed32 (*((uint32*) (&value)));
        }

        public size_t encode_int64 (int64 value)
        {
            return encode_varint (*((uint64*) (&value)));
        }

        public size_t encode_uint64 (uint64 value)
        {
            return encode_varint (value);
        }

        public size_t encode_int32 (int32 value)
        {
            return encode_int64 (value);
        }

        public size_t encode_fixed64 (uint64 value)
        {
            allocate (8);
            write_index -= 8;
            buffer[write_index] = (uint8) value;
            buffer[write_index + 1] = (uint8) (value >> 8);
            buffer[write_index + 2] = (uint8) (value >> 16);
            buffer[write_index + 3] = (uint8) (value >> 24);
            buffer[write_index + 4] = (uint8) (value >> 32);
            buffer[write_index + 5] = (uint8) (value >> 40);
            buffer[write_index + 6] = (uint8) (value >> 48);
            buffer[write_index + 7] = (uint8) (value >> 56);
            return 8;
        }

        public size_t encode_fixed32 (uint32 value)
        {
            allocate (4);
            write_index -= 4;
            buffer[write_index] = (uint8) value;
            buffer[write_index + 1] = (uint8) (value >> 8);
            buffer[write_index + 2] = (uint8) (value >> 16);
            buffer[write_index + 3] = (uint8) (value >> 24);
            return 4;
        }

        public size_t encode_bool (bool value)
        {
            return encode_varint (value ? 1 : 0);
        }

        public size_t encode_string (string value)
        {
            var length = value.length;
            allocate (length);
            write_index -= length;
            for (var i = 0; i < length; i++)
                buffer[write_index + i] = value[i];

            return length;
        }

        public size_t encode_bytes (GLib.ByteArray value)
        {
            allocate (value.len);
            write_index -= value.len;
            for (var i = 0; i < value.len; i++)
                buffer[write_index + i] = value.data[i];

            return value.len;
        }

        public size_t encode_uint32 (uint32 value)
        {
            return encode_varint (value);
        }

        public size_t encode_sfixed32 (int32 value)
        {
            return encode_fixed32 (*((uint32*) (&value)));
        }

        public size_t encode_sfixed64 (int64 value)
        {
            return encode_fixed64 (*((uint64*) (&value)));
        }

        public size_t encode_sint32 (int32 value)
        {
            if (value < 0)
                return encode_varint ((uint32) (-value) * 2 - 1);
            else
                return encode_varint ((uint32) value * 2);
        }

        public size_t encode_sint64 (int64 value)
        {
            if (value < 0)
                return encode_varint ((uint64) (-value) * 2 - 1);
            else
                return encode_varint ((uint64) value * 2);
        }

        public size_t encode_unknown_field (UnknownField value)
        {
            size_t n_written = 0;

            var wire_type = value.key & 0x7;
            switch (wire_type)
            {
            case 0: //varint
                n_written += encode_varint (value.varint);
                break;
            case 1: //64-bit
            case 5: //32-bit
                n_written += encode_bytes (value.data);
                break;
            case 2: //length-delimited
                n_written += encode_bytes (value.data);
                n_written += encode_varint (value.data.len);
                break;
            default: //FIXME: throw error
                GLib.stderr.printf ("Unknown wire type %" + uint64.FORMAT + "\n", wire_type);
                break;
            }

            n_written += encode_varint (value.key);

            return n_written;
        }

        private void allocate (size_t size)
        {
            var required = size + (buffer.length - write_index);
            if (required <= buffer.length)
                return;

            /* Double buffer until enough space */
            var new_length = buffer.length;
            while (required > new_length)
                new_length *= 2;

            /* Create new buffer and copy over data */
            var new_buffer = new uint8[new_length];
            var write_offset = new_buffer.length - buffer.length;
            for (var i = write_index; i < buffer.length; i++)
                new_buffer[i + write_offset] = buffer[i];

            /* Switch buffers */
            buffer = (owned) new_buffer;
            write_index += write_offset;
        }
    }

    public static string bytes_to_string (ByteArray value)
    {
        var text = "";
        for (var i = 0; i < value.len; i++)
            text += "%02X".printf (value.data[i]);
        return text;
    }

    public static string string_to_string (string value)
    {
        var v = value.replace ("\\", "\\\\");
        v = value.replace ("\"", "\\\"");
        return "\"%s\"".printf (v);
    }
}
