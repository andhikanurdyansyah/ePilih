$(document).ready(function () {
    var a = $("#datatable-buttons").DataTable({
        ajax: "/adm/admins/get-data/",
        columns: [
            { data: 'name' },
            { data: 'username' },
            {
                targets: -1,
                data: null,
                render: function (data, type, row, meta) {
                    return `<div class="d-flex">
                        <button class="btn btn-danger btn-sm mr-2 btn-hapus" data-id="${data.id}" data="${data.name}"><i class="uil uil-trash"></i></button>
                        <button class="btn btn-success btn-sm btn-ubah" data-id="${data.id}" data="${data.name}" data-username="${data.username}"><i class="uil uil-edit"></i></button>
                    </div>`
                }
            }
        ],
        lengthChange: !1,
        buttons: [
            {
                text: '<i class="uil uil-plus-circle"></i>',
                titleAttr: "Tambah Data",
                action: function () {
                    $('#modalTambah').modal('show')
                },
                className: "btn-table"
            },
            {
                extend: "print",
                text: '<i class="uil uil-print"></i>',
                titleAttr: "Print Data",
                customize: function (win) {
                    $(win.document.body).find('table').find('td:last-child, th:last-child').remove();
                },
                className: "btn-table"
            },
            {
                extend: "excel",
                text: "<i class='uil uil-download-alt'></i>",
                titleAttr: "Export to Excel",
                exportOptions: {
                    columns: ':not(:last-child)',
                },
                className: "btn-table"
            },
            {
                text: "<i class='uil uil-refresh'></i>",
                action: function ( e, dt, node, config ) {
                    dt.ajax.reload();
                },
                titleAttr: "Refresh Data",
                className: "btn-table"
            }
        ],
        language: {
            paginate: {
                previous: "<i class='uil uil-angle-left'>",
                next: "<i class='uil uil-angle-right'>"
            }
        },
        responsive: false,
        initComplete: function () {
            a.buttons().container().appendTo("#datatable-buttons_wrapper .col-md-6:eq(0)")
            $('.btn-table').addClass("btn-primary")
            $('.btn-table').removeClass("btn-secondary")
            $(".dataTables_paginate > .pagination").addClass("pagination-rounded")
        },
        drawCallback: function () {
            $('#datatable-buttons tbody').on('click', 'button.btn-hapus', function(){
                var name = $(this).attr('data')
                var id = $(this).attr('data-id')
        
                Swal.fire({
                    icon: 'warning',
                    html: 'Apakah anda yakin ingin menghapus <b>' + name + '</b>?',
                    showCancelButton: true,
                    confirmButtonText: "Yakin",
                    cancelButtonText: "Batal",
                    confirmButtonColor: '#5369f8',
                    cancelButtonColor: '#ff5c75',
                }).then((r) => {
                    if (r.isConfirmed) {
                        $.ajax({
                            headers: { "X-CSRFToken": token },
                            type: "POST",
                            url: '/adm/admins/delete/',
                            data: {"id": id},
                            dataType: "json",
                        }).done((result) => {
                            if (result.status) {
                                a.ajax.reload()
                            } else {
                                Swal.fire({
                                    text: result.message,
                                    icon: "warning",
                                    showConfirmButton: false,
                                    timer: 2000
                                })
                            }
                        })
                    }
                })
            })
        }
    });

    $('#formTambahData').on('submit', async function (e) {
        e.preventDefault()

        var data = new FormData()
        data.append("name", e.target.name.value)
        data.append("username", e.target.username.value)
        data.append("password", e.target.password.value)

        if (data.get('name') && data.get('username') && data.get('password')) {
            $(this).children('button').children('span.spinner-border').removeClass('d-none')
            $(this).children('button').addClass('disabled')
            await $.ajax({
                headers: { "X-CSRFToken": token },
                type: "POST",
                url: '/adm/admins/add/',
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                dataType: "json",
            }).done((result) => {
                if (result.status) {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
                    $(this).children('button').removeClass('disabled')

                    $('#modalTambah input').val('')

                    $('#modalTambah').modal('hide')

                    a.ajax.reload()
                } else {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
                    $(this).children('button').removeClass('disabled')

                    Swal.fire({
                        text: result.message,
                        icon: "warning",
                        showConfirmButton: false,
                        timer: 2000
                    })
                }
            })
        }
    })

    $('#datatable-buttons tbody').on('click', 'button.btn-ubah', function(){
        $('#formUbahData').attr('data-id', $(this).attr('data-id'))
        $('#formUbahData input#ubahName').val($(this).attr('data'))
        $('#formUbahData input#ubahUser').val($(this).attr('data-username'))
        $('#formUbahData input#ubahPw').val('')
        $('#modalUbah').modal('show')
    })

    $('#formUbahData').on('submit', async function (e) {
        e.preventDefault()

        var data = new FormData()
        data.append("name", e.target.name.value)
        data.append("username", e.target.username.value)
        data.append("password", e.target.password.value)
        data.append("id", $(this).attr("data-id"))

        if (data.get('name') && data.get('username')) {
            $(this).children('button').children('span.spinner-border').removeClass('d-none')
            $(this).children('button').addClass('disabled')
            await $.ajax({
                headers: { "X-CSRFToken": token },
                type: "POST",
                url: '/adm/admins/update/',
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                dataType: "json",
            }).done((result) => {
                if (result.status) {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
                    $(this).children('button').removeClass('disabled')

                    $('#modalUbah').modal('hide')

                    a.ajax.reload()
                } else {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
                    $(this).children('button').removeClass('disabled')

                    Swal.fire({
                        text: result.message,
                        icon: "warning",
                        showConfirmButton: false,
                        timer: 2000
                    })
                }
            })
        }
    })
})