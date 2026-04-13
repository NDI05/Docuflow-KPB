using System.ComponentModel.DataAnnotations;

namespace Docuflow_projectIT_KPB.Models
{
    public class User
    {
        public int Id { get; set; }

        public string Nama { get; set; } = string.Empty;

        public string Role { get; set; } = string.Empty;

        public string? TtdImagePath { get; set; }

        public string NomorPegawai { get; set; } = string.Empty;

        public string? Npk { get; set; }

        // LOGIN
        public string Username { get; set; } = string.Empty;

        public string Password { get; set; } = string.Empty;
    }
}