# Changelog

Semua perubahan penting pada Appbase dicatat di berkas ini.

Format mengikuti [Keep a Changelog](https://keepachangelog.com/id/1.1.0/),
dan proyek ini memakai [Semantic Versioning](https://semver.org/lang/id/).

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

[1.3.0]: https://github.com/guggie11/appbase-infrastructure/releases/tag/v1.3.0
[1.0.0]: https://github.com/guggie11/appbase-infrastructure/releases/tag/v1.0.0
