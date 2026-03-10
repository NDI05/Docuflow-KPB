namespace Docuflow_projectIT_KPB.Models
{
    public class User
    {
        public int Id { get; set; }

        public string Nama { get; set; } = string.Empty;

        public string Role { get; set; } = string.Empty;

        public string? TtdImagePath { get; set; }

        public string NomorPegawai { get; set; }

        public string? Npk { get; set; }
    }
}