$(document).ready(function () {
    var a = $("#datatable-buttons").DataTable({
        ajax: "/adm/voters/get-data/",
        columns: [
            { data: 'name' },
            { data: 'division' },
            { data: 'auth' },
            { data: 'vote_at' },
            { data: 'is_vote' },
            {
                targets: -1,
                data: null,
                render: function (data, type, row, meta) {
                    return `<div class="d-flex">
                        <button class="btn btn-danger btn-sm mr-2 btn-hapus" data-auth="${data.auth}" data="${data.name}"><i class="uil uil-trash"></i></button>
                        <button class="btn btn-success btn-sm btn-ubah mr-2" data-auth="${data.auth}" data="${data.name}" data-division-id="${data.division_id}"><i class="uil uil-edit"></i></button>
                        <button class="btn btn-warning btn-sm btn-reset" data-auth="${data.auth}" data="${data.name}"><i class="uil uil-history"></i></button>
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
                text: "<i class='uil uil-upload-alt'></i>",
                titleAttr: "Import from Excel",
                className: "btn-table",
                action: function () {
                    $('#modalImport').modal('show')
                },
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
                var auth = $(this).attr('data-auth')
        
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
                            url: '/adm/voters/delete/',
                            data: {"auth": auth},
                            dataType: "json",
                        }).done((result) => {
                            if (result.status) {
                                a.ajax.reload()
                            } else {
                                $('#preloader').removeClass('d-block')
                                $('#preloader #status').removeClass('d-block')
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
        data.append("division", e.target.division.value)

        if (data.get('name')) {
            $(this).children('button').children('span.spinner-border').removeClass('d-none')
            await $.ajax({
                headers: { "X-CSRFToken": token },
                type: "POST",
                url: '/adm/voters/add/',
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                dataType: "json",
            }).done((result) => {
                if (result.status) {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
                    $('#modalTambah input').val('')
                    $('#modalTambah').modal('hide')
                    a.ajax.reload()
                } else {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
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
        $('#formUbahData').attr('data-auth', $(this).attr('data-auth'))
        $('#formUbahData input#ubahName').val($(this).attr('data'))
        $('#formUbahData select#ubahDivisi').val($(this).attr('data-division-id')).change()
        $('#modalUbah').modal('show')
    })

    $('#formUbahData').on('submit', async function (e) {
        e.preventDefault()

        var data = new FormData()
        data.append("name", e.target.name.value)
        data.append("division", e.target.division.value)
        data.append("auth", $(this).attr("data-auth"))

        if (data.get('name')) {
            $(this).children('button').children('span.spinner-border').removeClass('d-none')
            await $.ajax({
                headers: { "X-CSRFToken": token },
                type: "POST",
                url: '/adm/voters/update/',
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                dataType: "json",
            }).done((result) => {
                if (result.status) {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
                    $('#modalUbah').modal('hide')
                    a.ajax.reload()
                } else {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
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

    $('#formUpload').on('change', '#file', function(){
        let files = $(this)[0].files[0]

        if(files){
            let name = files.name
            $(this).parent('label').children('div').children('span').text(name)
            $(this).parent('label').children('div').children('i').removeClass('uil-cloud-upload')
            $(this).parent('label').children('div').children('i').addClass('uil-file-alt')
        }
    })

    $('#formUpload').on('submit', async function (e) {
        e.preventDefault()

        document.getElementById('error').innerHTML = ''

        var data = new FormData()
        data.append("file", e.target.file.files[0])

        if (data.get('file')) {
            $(this).children('button').children('span.spinner-border').removeClass('d-none')
            await $.ajax({
                headers: { "X-CSRFToken": token },
                type: "POST",
                url: '/adm/voters/import/',
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                dataType: "json",
                enctype:"multipart/form-data",
            }).done((result) => {
                if (result.status) {
                    if(result.error['error_division'] > 0){
                        document.getElementById('error').innerHTML = `
                        <div class="alert alert-danger"><i class="uil uil-exclamation-triangle mr-2"></i>Terdapat <b>${result.error['error_division']}</b> baris dengan divisi tidak ditemukan!</div>
                        `
                    }
                    if(result.error['error_null'] > 0){
                        document.getElementById('error').innerHTML += `
                        <div class="alert alert-danger"><i class="uil uil-exclamation-triangle mr-2"></i>Terdapat <b>${result.error['error_null']}</b> baris dengan cell kosong!</div>
                        `
                    }
                    $(this).children('button').children('span.spinner-border').addClass('d-none')

                    if(result.error['error_division'] == 0 && result.error['error_null'] == 0){
                        $('#modalImport').modal('hide')
                    }

                    $('#formUpload #file').parent('label').children('div').children('span').text("Klik untuk upload file")
                    $('#formUpload #file').parent('label').children('div').children('i').addClass('uil-cloud-upload')
                    $('#formUpload #file').parent('label').children('div').children('i').removeClass('uil-file-alt')
                    a.ajax.reload()
                    e.target.file.value = ''
                } else {
                    $(this).children('button').children('span.spinner-border').addClass('d-none')
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

    $('#datatable-buttons tbody').on('click', 'button.btn-reset', function(){
        var name = $(this).attr('data')
        var auth = $(this).attr('data-auth')

        Swal.fire({
            icon: 'warning',
            html: 'Apakah anda yakin ingin mereset status voting <b>' + name + '</b>?',
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
                    url: '/adm/voters/reset/',
                    data: {"auth": auth},
                    dataType: "json",
                }).done((result) => {
                    if (result.status) {
                        a.ajax.reload()
                    } else {
                        $('#preloader').removeClass('d-block')
                        $('#preloader #status').removeClass('d-block')
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

    $('[data-plugin="customselect"]').select2()
})