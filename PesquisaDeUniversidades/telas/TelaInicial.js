import React, { useState } from 'react';
import { View, Text, TextInput, Button, FlatList, TouchableOpacity, Alert } from 'react-native';
import { MMKV } from 'react-native-mmkv';

const storage = new MMKV();

export default function TelaInicial({ navigation }) {
  const [country, setCountry] = useState('');
  const [name, setName] = useState('');
  const [universities, setUniversities] = useState([]);

  const PesquisarUniversidade = async () => {
    let url = 'http://universities.hipolabs.com/search?';
    if (country) url += `country=${country}&`;
    if (name) url += `name=${name}`;

    try {
      const response = await fetch(url);
      const data = await response.json();
      if (data.length === 0) {
        Alert.alert('Nenhuma universidade encontrada', 'Tente com outras palavras-chave.');
      } else {
        setUniversities(data);
      }
    } catch (error) {
      console.error(error);
      Alert.alert('Erro', 'Ocorreu um erro ao buscar as universidades.');
    }
  };

  const Favoritar = (university) => {
    let favorites = JSON.parse(storage.getString('favorites') || '[]');
    favorites.push(university);
    storage.set('favorites', JSON.stringify(favorites));
    alert('A universidade foi salva nos favoritos.');
  };

  return (
    <View style={{ flex: 1, padding: 20 }}>
      <TextInput value={country} onChangeText={setCountry} placeholder='País da Universidade' style={{ borderWidth: 1.5, marginBottom: 10, padding: 10, borderCurve: 0.5}} />
      <TextInput value={name} onChangeText={setName} placeholder='Nome da Universidade' style={{ borderWidth: 1.5, marginBottom: 10, padding: 10, borderCurve: 0.5 }} />
      <View style={{ flexDirection: 'row'}}>
        <Button title="PESQUISAR" onPress={PesquisarUniversidade} />
        <Button title="FAVORITOS" onPress={() => navigation.navigate('Favoritos')} />
      </View>
      <FlatList
        data={universities}
        keyExtractor={(item) => item.name}
        renderItem={({ item }) => (
          <TouchableOpacity onPress={() => Favoritar(item)}>
            <Text style={{ padding: 10, borderBottomWidth: 1 }}>{item.name}</Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
