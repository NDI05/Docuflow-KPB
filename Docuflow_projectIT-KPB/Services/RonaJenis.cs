namespace Docuflow_projectIT_KPB.Services
{
    /// <summary>
    /// Warna penanda jenis surat.
    ///
    /// Arsip yang semua chip-nya satu warna tidak bisa dipindai dengan mata.
    /// Rona diputar lewat sisa bagi Id jenis, bukan disimpan sebagai kolom:
    /// tidak ada CRUD untuk JenisSurat, jadi kolom warna tidak akan pernah
    /// bisa diisi siapa pun dan hanya akan jadi kolom kosong permanen.
    ///
    /// Dipakai chip kode nomor surat (_Nomor.cshtml) dan garis tepi kolom
    /// jenis (Surat/Index.cshtml). Ditaruh di sini supaya keduanya tidak
    /// pernah memakai pembagi yang berbeda — dua salinan angka ini pernah
    /// membuat satu surat berwarna A di chip dan B di kolom sebelahnya.
    ///
    /// ponytail: warna berulang setelah jenis kesembilan. Saat jenis ke-10
    /// ditambahkan, tambah rona di docuflow.css lalu naikkan Jumlah — nilai
    /// keduanya harus sama.
    /// </summary>
    public static class RonaJenis
    {
        /// <summary>Banyak rona yang didefinisikan di wwwroot/css/docuflow.css.</summary>
        public const int Jumlah = 9;

        public static int Untuk(int jenisSuratId) => jenisSuratId % Jumlah;
    }
}
