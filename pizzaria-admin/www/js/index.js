document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    cordova.plugin.http.setDataSerializer('json');
    LoadPizzas(); 
}

const PIZZARIA_ID = 'Pizza do Damaa';
var listaPizzasCadastradas = [];

function LoadPizzas() {
    var url = 'https://pedidos-pizzaria.glitch.me/admin/pizzas/' + PIZZARIA_ID;

    cordova.plugin.http.get(url, {}, {}, function(response) {
        if (response.data !== "") {
            listaPizzasCadastradas = JSON.parse(response.data);

            document.getElementById('listaPizzas').innerHTML = '';

            listaPizzasCadastradas.forEach(function(item, idx) {
                var p = document.createElement('p');
                var pizza = document.createElement('button');
                pizza.classList.add('linha');
                pizza.style.width = '100%';
                pizza.style.textAlign = 'left';
                pizza.style.padding = '10px';
                pizza.innerHTML = item.pizza;
                pizza.id = idx;
                pizza.onmouseover = function() {
                    pizza.style.backgroundColor = 'lightgray';
                };
                pizza.onmouseout = function() {
                    pizza.style.backgroundColor = 'transparent';
                };
                pizza.onclick = function() {
                    LoadPizzaID(pizza.id);
                };

                p.appendChild(pizza);
                document.getElementById('listaPizzas').appendChild(p);
            });
        }
    }, function(response) {
        console.error('Erro ao carregar as pizzas: ' + response.error);
    });
}

function LoadPizzaID(id) {
    var pizzaSelecionada = listaPizzasCadastradas[id];
    document.getElementById('pizza').value = pizzaSelecionada.pizza;
    document.getElementById('preco').value = pizzaSelecionada.preco;

    var imageData;
    if (pizzaSelecionada.imagem && typeof pizzaSelecionada.imagem === 'string' && pizzaSelecionada.imagem.startsWith('data:image/jpeg;base64,')) {
        imageData = pizzaSelecionada.imagem.split(',')[1];
    } else {
        imageData = pizzaSelecionada.imagem;
    }

    document.getElementById('imagem').style.backgroundImage = "url('data:image/jpeg;base64," + imageData + "')";
    document.getElementById('imagem').dataset.imageData = imageData; 
    document.getElementById('btnSalvar').style.display = 'block';
    document.getElementById('btnExcluir').style.display = 'block';
    document.getElementById('applista').style.display = 'none';
    document.getElementById('appcadastro').style.display = 'flex';
    document.getElementById('appcadastro').dataset.id = id;
}

function NewPizzaBtn() {
    document.getElementById('pizza').value = '';
    document.getElementById('preco').value = '';
    document.getElementById('imagem').style.backgroundImage = 'none';
    delete document.getElementById('imagem').dataset.imageData;

    document.getElementById('btnSalvar').style.display = 'block';
    document.getElementById('btnExcluir').style.display = 'block';
    document.getElementById('applista').style.display = 'none';
    document.getElementById('appcadastro').style.display = 'flex';
}

document.getElementById('btnFoto').addEventListener('click', function() {
    var options = {
        quality: 25,
        destinationType: Camera.DestinationType.DATA_URL,
    };

    navigator.camera.getPicture(function(imageData) {
        compressImage("data:image/jpeg;base64," + imageData, function(compressedImageData) {
            document.getElementById('imagem').style.backgroundImage = "url('" + compressedImageData + "')";
            document.getElementById('imagem').dataset.imageData = compressedImageData.split(',')[1]; 
        });
    }, function(message) {
        console.error('Erro ao tirar foto: ' + message);
    }, options);
});

// Função para comprimir imagem utilizando a biblioteca Pica
function compressImage(dataUrl, callback) {
    var img = new Image();
    img.src = dataUrl;
    img.onload = function() {
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');
        canvas.width = img.width;
        canvas.height = img.height;
        ctx.drawImage(img, 0, 0);

        var targetCanvas = document.createElement('canvas');
        targetCanvas.width = img.width * 0.5; 
        targetCanvas.height = img.height * 0.5; 

        pica().resize(canvas, targetCanvas)
            .then(result => pica().toBlob(result, 'image/jpeg', 0.5)) 
            .then(blob => {
                var reader = new FileReader();
                reader.readAsDataURL(blob);
                reader.onloadend = function() {
                    callback(reader.result);
                }
            });
    }
}

document.getElementById('btnSalvar').addEventListener('click', function() {
    var pizza = document.getElementById('pizza').value;
    var preco = document.getElementById('preco').value;
    var imageData = document.getElementById('imagem').dataset.imageData;

    var formData = {
        pizzaria: PIZZARIA_ID,
        pizza: pizza,
        preco: preco,
        imagem: imageData
    };

    cordova.plugin.http.post('https://pedidos-pizzaria.glitch.me/admin/pizza/', formData, {}, function(response) {
        console.log('Pizza cadastrada com sucesso:', response.data);
        alert('Pizza cadastrada com sucesso!');
        LoadPizzas();

        document.getElementById('applista').style.display = 'flex';
        document.getElementById('appcadastro').style.display = 'none';
    }, function(response) {
        console.error('Erro ao cadastrar a pizza:', response.error);
    });
});

document.getElementById('btnExcluir').addEventListener('click', function() {
    var idPizza = document.getElementById('appcadastro').dataset.id;
    var pizzaSelecionada = listaPizzasCadastradas[idPizza];
    var url = 'https://pedidos-pizzaria.glitch.me/admin/pizza/' + PIZZARIA_ID + '/' + pizzaSelecionada.pizza;

    cordova.plugin.http.delete(url, {}, {}, function(response) {
        console.log('Pizza excluída com sucesso:', response.data);
        alert('Pizza excluída com sucesso!');
        LoadPizzas();

        document.getElementById('applista').style.display = 'flex';
        document.getElementById('appcadastro').style.display = 'none';
    }, function(response) {
        console.error('Erro ao excluir a pizza:', response.error);
    });
});

document.getElementById('btnCancelar').addEventListener('click', function() {
    document.getElementById('applista').style.display = 'flex';
    document.getElementById('appcadastro').style.display = 'none';
});

document.getElementById('btnNovo').addEventListener('click', NewPizzaBtn);

document.getElementById('btnCancelar').addEventListener('click', function() {
    document.getElementById('applista').style.display = 'flex';
    document.getElementById('appcadastro').style.display = 'none';
});
