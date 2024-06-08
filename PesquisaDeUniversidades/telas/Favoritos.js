import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity, Alert } from 'react-native';
import { MMKV } from 'react-native-mmkv';

const storage = new MMKV();

export default function Favoritos() {
  const [favorites, setFavorites] = useState([]);

  useEffect(() => {
    const storedFavorites = JSON.parse(storage.getString('favorites') || '[]');
    setFavorites(storedFavorites);
  }, []);

  const Desfavoritar = (university) => {
    let favorites = JSON.parse(storage.getString('favorites') || '[]');
    favorites = favorites.filter((fav) => fav.name !== university.name);
    storage.set('favorites', JSON.stringify(favorites));
    setFavorites(favorites);
    alert('A universidade foi removida dos favoritos.');
  };

  return (
    <View style={{ flex: 1, padding: 20 }}>
      <FlatList
        data={favorites}
        keyExtractor={(item) => item.name}
        renderItem={({ item }) => (
          <TouchableOpacity onPress={() => Desfavoritar(item)}>
            <Text style={{ padding: 10, borderBottomWidth: 1 }}>{item.web_pages[0]}</Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
