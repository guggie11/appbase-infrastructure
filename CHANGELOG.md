# Changelog

Semua perubahan penting pada Appbase dicatat di berkas ini.

Format mengikuti [Keep a Changelog](https://keepachangelog.com/id/1.1.0/),
dan proyek ini memakai [Semantic Versioning](https://semver.org/lang/id/).

## [1.4.0] — 2026-10-27

Dua tambahan yang mengubah Appbase dari aplikasi contoh menjadi template yang
menghemat pekerjaan sehari-hari, bukan hanya penyiapan awal.

### Ditambahkan

- **Generator modul CRUD** — satu perintah menghasilkan modul utuh di backend
  dan frontend:

  ```
  uv run python scripts/generate_module.py Product \
      --fields "name:str,price:int,note:text,is_active:bool" \
      --frontend ../appbase-frontend
  ```

  Menghasilkan model, schema, service, router, migrasi, test, permission CRUD,
  entri menu, lalu di sisi frontend queries, halaman daftar, dan modal form.
  Rute yang dihasilkan selalu dibungkus `PermissionRoute` — tanpa itu siapa pun
  bisa membuka halaman dengan mengetik URL. Tersedia `--dry-run`, dan generator
  menolak jalan bila berkas tujuan sudah ada.

- **Category Management** — data referensi generik yang dirujuk fitur lain,
  supaya proyek turunan berhenti menanam daftar status dan klasifikasi di kode.
  Group adalah wadah bertema dengan kode yang dipakai fitur lain; Category
  adalah item di dalamnya, bersarang sedalam apa pun.

  Fitur lain cukup memanggil `GET /categories/by-group/{code}` — hanya item
  aktif yang dikembalikan, jadi nilai yang sudah tidak boleh dipilih tidak
  pernah sampai ke pemilih mana pun.

  **Appbase tidak menyemai satu group pun.** Kosakata adalah milik proyek yang
  memakai template.

  Integritas referensi dijaga basis data: fitur menyimpan foreign key dengan
  `ON DELETE RESTRICT`, sehingga menghapus nilai yang masih dirujuk ditolak
  PostgreSQL — bukan oleh pemeriksaan di lapisan aplikasi yang bisa
  ketinggalan ketika tabel baru ditambahkan. Jalur normalnya **deprecate**:
  nilai hilang dari pemilih, alasannya wajib diisi, dan seluruh rujukan lama
  tetap utuh.

### Diperbaiki

- **Foreign key tidak pernah ditegakkan saat pengujian.** SQLite mengabaikan
  foreign key kecuali diminta, dan `PRAGMA foreign_keys` tidak pernah ada.
  Artinya setiap `ON DELETE` di skema selama ini hanya hiasan: pengujian yang
  menyatakan sebuah baris terlindungi akan lulus sementara basis data dengan
  senang hati menghapusnya.

- **Seed gagal diam-diam ketika beberapa pekerja menyala bersamaan.** Dua
  proses server menyemai serempak; keduanya melihat slug belum ada, keduanya
  menyisipkan, lalu transaksi yang kalah dibuang seluruhnya sehingga setiap
  baris berikutnya dilewati tanpa pesan apa pun.

- **Logo meleset saat sidebar dikecilkan** — baris brand memakai
  `space-between`, sehingga ketika menyempit dan hanya berisi logo, logonya
  terlempar ke tepi.

## [1.3.1] — 2026-10-06

### Diperbaiki

- **Pemasangan baru berakhir tanpa peran sama sekali.** Urutan yang
  didokumentasikan menjalankan aplikasi sebelum migrasi, sehingga seed saat
  mulai gagal pada basis data kosong dan tidak pernah diulang. Akibatnya
  `create_superadmin.py` berhenti dengan `role 'super-admin' not found`.
  Kini tersedia opsi `--seed` yang menyemai peran dan permission bila belum
  ada, dan README memakainya sebagai langkah baku.

## [1.3.0] — 2026-10-06

Rilis ini menjadikan Appbase benar-benar bisa dipakai sebagai template: sampai
versi sebelumnya, hasil clone **tidak bisa dijalankan sampai selesai**.

### Ditambahkan

- **Permission matrix RESOURCE × ACTION** — permission ditampilkan sebagai grid
  dengan kolom View / Create / Edit / Delete / Approve. Baris resource diambil
  dari katalog backend, jadi modul yang ditambahkan nanti muncul tanpa
  menyentuh frontend.
- **`GET /permissions/matrix`** — struktur grid, lengkap dengan penanda sel yang
  tidak berlaku untuk resource tertentu.
- **`scripts/create_superadmin.py`** — membuat administrator pertama. Idempoten,
  kredensial dari argumen atau variabel lingkungan, tanpa password bawaan.
- **Halaman Appearance** — lima preset warna, pemeriksaan kontras WCAG otomatis,
  pratinjau komponen sungguhan, dan status perubahan belum tersimpan.
- **Aksi massal pengguna** — ubah peran dan status beberapa pengguna sekaligus,
  impor CSV baris-per-baris, kolom aktivitas terakhir.
- **Menu berbasis permission** — menu terikat pada permission, bukan peran, plus
  pratinjau "lihat sebagai peran".
- **Admin Console bertab** — Users, Roles & Permissions, Menu Management,
  Appearance, Settings dalam satu halaman.
- **Peran dapat diduplikasi**, punya jenis (Platform / Built-in / Custom), dan
  menampilkan jumlah pemegangnya.

### Diubah

- **Permission diseragamkan menjadi CRUD.** `menu`, `settings`, dan
  `notifications` sebelumnya hanya punya satu permission borongan `.manage`,
  sehingga tidak mungkin memberi hak "boleh lihat dan ubah, tapi jangan hapus".
  Katalog bertambah dari 20 menjadi 31 permission.
- Permission `.manage` lama **tetap berlaku** — pemegangnya tidak kehilangan
  akses saat memperbarui. `.manage` tidak memberi hak melihat atau menyetujui.
- Peran platform dikunci di backend (HTTP 403), bukan sekadar disembunyikan di
  antarmuka.
- `.env.example` memakai nama service Docker (`db`, `redis`); `localhost` di
  dalam container merujuk container itu sendiri.
- `container_name` dihapus dari berkas compose sehingga beberapa instalasi
  Appbase bisa berjalan bersamaan di satu mesin.
- README diselaraskan dengan perintah yang benar-benar berfungsi.

### Diperbaiki

- **Hasil clone tidak bisa di-build** — compose menunjuk Dockerfile di dalam
  repositori backend, padahal berkasnya ada di repositori infrastructure.
- **Tidak ada cara membuat pengguna pertama** — seed membuat permission, peran,
  dan pengaturan, tetapi nol pengguna. Aplikasi terkunci dari dirinya sendiri.
- **Super Admin tidak memegang satu pun permission di basis data** — seed tidak
  pernah menempelkannya; sistem aman hanya karena ada jalur pintas super-admin.
- **`/auth/me` tidak mengirim peran dan permission**, sehingga pemeriksaan hak
  di frontend hanya tiruan yang selalu meluluskan.
- **`GET /permissions` mengembalikan senarai telanjang** tanpa pembungkus
  seperti endpoint lain, membuat matrix tampil kosong tanpa pesan kesalahan.
- **Migrasi tidak pernah masuk git** — `.gitignore` memblokir
  `alembic/versions/*.py`, termasuk skema awal. Hasil clone tidak bisa
  membangun basis data sama sekali.
- Kegagalan seed tidak lagi ditelan diam-diam; kini tercatat di log.
- Label permission yang diganti nama tidak pernah sampai ke basis data karena
  seed hanya memperbarui sebagian kolom.

### Keamanan

- Aksi massal menolak mengenai akun pemanggilnya sendiri — tidak ada yang bisa
  membatalkan admin yang mencabut aksesnya sendiri.
- `create_superadmin.py` menolak kata sandi di bawah 12 karakter dan menolak
  berjalan bila peran belum di-seed.

## [1.0.0] — 2026-09

Rilis pertama: autentikasi JWT, RBAC, menu dinamis, audit log, notifikasi,
undangan pengguna, OAuth/SSO, dan pengaturan tampilan aplikasi.

[1.3.1]: https://github.com/guggie11/appbase-infrastructure/releases/tag/v1.3.1
[1.3.0]: https://github.com/guggie11/appbase-infrastructure/releases/tag/v1.3.0
[1.0.0]: https://github.com/guggie11/appbase-infrastructure/releases/tag/v1.0.0
